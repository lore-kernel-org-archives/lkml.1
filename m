Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbXFPRNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbXFPRNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 13:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXFPRNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 13:13:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:45724 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbXFPRNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 13:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n8r8iQFXQ3BfjtYPIsQV6bTvOUIeNqilakChLIsLcfPgYKLuTfvFpZG68Fj05mNOSVIpWHg5GiytbpE0VXj4wGRaxVSw5Gyx3KwZABUxKmQs5iq7X/pt8GB98gntbbKAR3vALlMqPIZoRN5oO3fCRmoFNVaKDkcxJOVHjs//xe4=
Subject: Re: [patch] Reporting the lid status using INPUT
From: Richard Hughes <hughsient@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>, a_bartok@freemail.hu,
       Bastien Nocera <hadess@hadess.net>, David Zeuthen <david@fubar.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1181919208.2681.6.camel@work>
References: <1181910567.4819.7.camel@work> <1181913179.21041.3.camel@work>
	 <d120d5000706150729i24763e00o7d2c48ef16960b2f@mail.gmail.com>
	 <1181919208.2681.6.camel@work>
Content-Type: text/plain
Date: Sat, 16 Jun 2007 18:11:51 +0100
Message-Id: <1182013911.2309.4.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 15:53 +0100, Richard Hughes wrote:
> On Fri, 2007-06-15 at 10:29 -0400, Dmitry Torokhov wrote:
> > On 6/15/07, Richard Hughes <hughsient@gmail.com> wrote:
> > > On Fri, 2007-06-15 at 13:29 +0100, Richard Hughes wrote:
> > > > in response to an event, but I'm thinking in a resume hook we should
> > > > probably do acpi_evaluate_integer(handle, "_LID", NULL, &state) and then
> > > > send an event, just so userspace is aware of what the state of the panel
> > > > is.
> > >
> > > Attached patch fixed the issue for me. Comments?
> > >
> > 
> > The patch makes perfect sense. The only issue I have is this:
> > 
> > > +	/* on resume we send the state; it might be the same, but userspace
> > > +	 * should handle duplicated events */
> > 
> > If switch state matches to what input layer thinks it is the event
> > will not even reach userspace.
> 
> Okay, new patch attached, thanks for the speedy review.

This fix is also confirmed by somebody else, see
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243030

It would be great if this could go into .22, although I appreciate it's
quite late in the day.

Richard.


