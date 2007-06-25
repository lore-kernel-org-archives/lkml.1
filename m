Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbXFYVZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbXFYVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXFYVZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:25:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:14808 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbXFYVZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aEbYVw7qvdZmKiOT/UxGgjqLDllhXCTuo/aZIAM1HoL4KsAv77RPE05hvkoK1pSn3Y+jGx+cYjfzUrBYTIBUWyvC5GgihORsveQ4nf2HZmMz+x1piXk3uOWVyoNf5kPZDUZ8tI2rvya0kgoVvBLHSFyX+ZNjA9oTPi1deZLYQnk=
Subject: Re: [patch] Reporting the lid status using INPUT
From: Richard Hughes <hughsient@gmail.com>
To: =?ISO-8859-1?Q?Bart=F3k?= Albert <a_bartok@freemail.hu>
Cc: Dmitry Torokhov <dtor@insightbb.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bastien Nocera <hadess@hadess.net>, David Zeuthen <david@fubar.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>, len.brown@intel.com
In-Reply-To: <freemail.20070525224936.77205@fm01.freemail.hu>
References: <freemail.20070525224936.77205@fm01.freemail.hu>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 25 Jun 2007 22:24:59 +0100
Message-Id: <1182806699.2299.16.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 22:49 +0200, Bartók Albert wrote:
> GMail On 16/06/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> > On Saturday 16 June 2007 13:11, Richard Hughes wrote:
> > > On Fri, 2007-06-15 at 15:53 +0100, Richard Hughes wrote:
> > > > On Fri, 2007-06-15 at 10:29 -0400, Dmitry Torokhov wrote:
> > > > > On 6/15/07, Richard Hughes <hughsient@gmail.com> wrote:
> > > > > > On Fri, 2007-06-15 at 13:29 +0100, Richard Hughes wrote:
> > > > > > > in response to an event, but I'm thinking in a resume hook we should
> > > > > > > probably do acpi_evaluate_integer(handle, "_LID", NULL, &state) and then
> > > > > > > send an event, just so userspace is aware of what the state of the panel
> > > > > > > is.
> > > > > >
> > > > > > Attached patch fixed the issue for me. Comments?
> > > > > >
> > > > >
> > > > > The patch makes perfect sense. The only issue I have is this:
> > > > >
> > > > > > +       /* on resume we send the state; it might be the same, but userspace
> > > > > > +        * should handle duplicated events */
> > > > >
> > > > > If switch state matches to what input layer thinks it is the event
> > > > > will not even reach userspace.
> > > >
> > > > Okay, new patch attached, thanks for the speedy review.
> > >
> > > This fix is also confirmed by somebody else, see
> > > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243030
> > >
> > > It would be great if this could go into .22, although I appreciate it's
> > > quite late in the day.
> > >
> >
> > This is of course Len's call but in my book this is a bugfix and as such
> > is appropriate for -rc4/rc5.
> 
> > Guys? Any ack-nak?
> 
> works perfectly for me so far.

Thanks. Len, can you add this to your tree please. Thanks.

Richard.


