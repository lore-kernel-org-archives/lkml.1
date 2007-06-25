Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbXFYU40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbXFYU40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbXFYU4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:56:19 -0400
Received: from fmx03.freemail.hu ([195.228.245.53]:59507 "HELO
	fmx03.freemail.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750718AbXFYU4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:56:18 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2007 16:56:18 EDT
Date: Mon, 25 Jun 2007 22:49:36 +0200 (CEST)
From: =?ISO-8859-2?Q?Bart=F3k_Albert?= <a_bartok@freemail.hu>
Subject: Re: [patch] Reporting the lid status using INPUT
To: GMail <hughsient@gmail.com>
cc: Dmitry Torokhov <dtor@insightbb.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bastien Nocera <hadess@hadess.net>, David Zeuthen <david@fubar.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <15e53e180706241506p53ec648ib93d684bbe076a46@mail.gmail.com>
Message-ID: <freemail.20070525224936.77205@fm01.freemail.hu>
X-Originating-IP: [131.111.8.102]
X-HTTP-User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070603 Fedora/2.0.0.4-2.fc7 Firefox/2.0.0.4
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org





GMail On 16/06/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> On Saturday 16 June 2007 13:11, Richard Hughes wrote:
> > On Fri, 2007-06-15 at 15:53 +0100, Richard Hughes wrote:
> > > On Fri, 2007-06-15 at 10:29 -0400, Dmitry Torokhov wrote:
> > > > On 6/15/07, Richard Hughes <hughsient@gmail.com> wrote:
> > > > > On Fri, 2007-06-15 at 13:29 +0100, Richard Hughes wrote:
> > > > > > in response to an event, but I'm thinking in a resume hook we should
> > > > > > probably do acpi_evaluate_integer(handle, "_LID", NULL, &state) and then
> > > > > > send an event, just so userspace is aware of what the state of the panel
> > > > > > is.
> > > > >
> > > > > Attached patch fixed the issue for me. Comments?
> > > > >
> > > >
> > > > The patch makes perfect sense. The only issue I have is this:
> > > >
> > > > > +       /* on resume we send the state; it might be the same, but userspace
> > > > > +        * should handle duplicated events */
> > > >
> > > > If switch state matches to what input layer thinks it is the event
> > > > will not even reach userspace.
> > >
> > > Okay, new patch attached, thanks for the speedy review.
> >
> > This fix is also confirmed by somebody else, see
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243030
> >
> > It would be great if this could go into .22, although I appreciate it's
> > quite late in the day.
> >
>
> This is of course Len's call but in my book this is a bugfix and as such
> is appropriate for -rc4/rc5.

> Guys? Any ack-nak?

works perfectly for me so far.

Albert



15% KEDVEZMÉNY minden PLASZTIKAI MÛTÉTRE az Aesthetica orvosi központban! Klikk ide!http://www.webdesign.hu/aesthetica/flash_microsite/?id=9;p_code=2079

