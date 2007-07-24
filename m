Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbXGXVpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbXGXVpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXGXVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:45:25 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:23341 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbXGXVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:45:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MAsKyLf9Q8u+GqKNQTznmWlrtmaMccGo6CwSZImVt6nNKmx3poVdgesFVAgBoZYNX3tHnrEwYlAjXENEydj3S2bAN6kWD7b1+PltrOYeSY4/Wd4xTvv3c73GZynP8Nfzj2eP0rfS8q/Ga6fMZU7YYX8OISi0jgnE1PSFo77JiX8=
Message-ID: <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
Date: Tue, 24 Jul 2007 22:45:23 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Problems with framebuffer in 2.6.22-git17
Cc: "Adrian McMenamin" <adrianmcmenamin@gmail.com>,
       linux-kernel@vger.kernel.org, lethal@users.sourceforge.net
In-Reply-To: <1185146563.6370.8.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <1185146563.6370.8.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Sun, 2007-07-22 at 19:41 +0100, Adrian McMenamin wrote:
> > I ma having problems with the pvr2 fb on the Dreamcast in 2.6.22-git17
> > - when the code is executed it appears to lock the Dreamcast up.
> >
> > The problem seems to be:
> >
> >  fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
> >
> > In drivers/video/fbmem.c
> >
> > This hasn't been an issue before, so are there any recent changes that
> > might have caused this?
>
> What's the last kernel that worked for you? Can you also post your
> config?
>
> >
> > (fb_notifier_call_chain calls a succession of stubs ending in
> > __blocking_notifier_call_chain in kernel/sys.c)
> >
>
> Try reverting commit a66ad56eb2c9644717da4d7f05f971d6786145e3.
>
> Tony
>

Tony,

I have checked this a few times now, including against Paul's git as
well as Linus's and the Dreamcast won't boot without its reversion.
Don't know why, but it needs to be reverted until a better fix is
available.

Adrian
