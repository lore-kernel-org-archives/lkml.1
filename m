Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbXFPRvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbXFPRvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 13:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXFPRvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 13:51:31 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:11290 "EHLO
	asav18.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXFPRva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 13:51:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXAJXAc0ZKhRO4UGdsb2JhbACPLAEBGw0GEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Richard Hughes <hughsient@gmail.com>
Subject: Re: [patch] Reporting the lid status using INPUT
Date: Sat, 16 Jun 2007 13:51:27 -0400
User-Agent: KMail/1.9.3
Cc: linux-acpi <linux-acpi@vger.kernel.org>, a_bartok@freemail.hu,
       Bastien Nocera <hadess@hadess.net>, David Zeuthen <david@fubar.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1181910567.4819.7.camel@work> <1181919208.2681.6.camel@work> <1182013911.2309.4.camel@work>
In-Reply-To: <1182013911.2309.4.camel@work>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706161351.28885.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007 13:11, Richard Hughes wrote:
> On Fri, 2007-06-15 at 15:53 +0100, Richard Hughes wrote:
> > On Fri, 2007-06-15 at 10:29 -0400, Dmitry Torokhov wrote:
> > > On 6/15/07, Richard Hughes <hughsient@gmail.com> wrote:
> > > > On Fri, 2007-06-15 at 13:29 +0100, Richard Hughes wrote:
> > > > > in response to an event, but I'm thinking in a resume hook we should
> > > > > probably do acpi_evaluate_integer(handle, "_LID", NULL, &state) and then
> > > > > send an event, just so userspace is aware of what the state of the panel
> > > > > is.
> > > >
> > > > Attached patch fixed the issue for me. Comments?
> > > >
> > > 
> > > The patch makes perfect sense. The only issue I have is this:
> > > 
> > > > +	/* on resume we send the state; it might be the same, but userspace
> > > > +	 * should handle duplicated events */
> > > 
> > > If switch state matches to what input layer thinks it is the event
> > > will not even reach userspace.
> > 
> > Okay, new patch attached, thanks for the speedy review.
> 
> This fix is also confirmed by somebody else, see
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243030
> 
> It would be great if this could go into .22, although I appreciate it's
> quite late in the day.
>

This is of course Len's call but in my book this is a bugfix and as such
is appropriate for -rc4/rc5.

-- 
Dmitry
