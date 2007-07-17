Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbXGQGU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbXGQGU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXGQGUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:20:18 -0400
Received: from 69-12-177-67.dsl.static.sonic.net ([69.12.177.67]:38082 "EHLO
	orion.sysdev.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751858AbXGQGUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:20:17 -0400
Date: Mon, 16 Jul 2007 22:20:58 -0800
From: Tony Borras <tonyb@sysdev.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.35 tree abandoned/delayed?
Message-Id: <20070716222058.6d2a979a.tonyb@sysdev.org>
In-Reply-To: <8HNDE-JM-11@gated-at.bofh.it>
References: <8HJqo-2BV-23@gated-at.bofh.it>
	<8HJqo-2BV-21@gated-at.bofh.it>
	<8HNDE-JM-11@gated-at.bofh.it>
Organization: SysDev Inc.
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; i686-pc-linux-gnu)
X-Operating-System: Linux-2.6.27-SMP64
X-SlakBoot: SlakbootIBS v11.0.2
User-Agent: Sylpheed/1.0.6
X-Sylpheed-Rules: You Bet
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 07:20:06 +0200
Willy Tarreau <w@1wt.eu> wrote:

> Hi Tony,
> 
> On Mon, Jul 16, 2007 at 04:30:47PM -0800, Tony Borras wrote:
> > I did get the current 'pre' set of 2.4.35 (circa early
> > June) patches and applied to 2.4.34.5.  After fixing a goto
> > mislable in one of the patches (dont remember if it was one
> > of the patch-2.4.34.? or patch-2.4.35.pre5), managed to
> > build a vmlinuz-2.4.35 successfully.
> 
> could you please report what the problem was, in case it's not
> fixed yet ?
> 
> > Just wondered whether to expect an abandonded tree, in which
> > case I will fly with this 2.4.35 build or should wait for
> > its eventual release.
>  
> No it's not abandonned at all !!!

My process was to start with 2.4.34 sources (that compiled
fine), applied the 2.4.34.[1-5] patches and then the 2.4.35.rc5.

I didnt patch the patches. I changed a jmp reference to a
non-existent label to the correct label, in the one file that
complained at build time.

So have to repeat the full process, again.  Will let you know...

TonyB


There are 10 types of people in this world, those that read
binary and those who don't!

--
  __      __  _     I N C.               http://www.sysdev.org
/ __|\\// __||  \  __   __          /         tonyb@sysdev.org
\__ \ \/\__ \||)|/ O_)\/ /        \/  System Tools / Utilities
|___/ || ___/|_ /\___|\_/        WIntel / Linux Device Drivers

