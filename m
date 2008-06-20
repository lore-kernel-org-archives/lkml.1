Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYFTKu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYFTKu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYFTKuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:50:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54567 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbYFTKuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:50:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Bisecting tip/auto-x86-next?
Date: Fri, 20 Jun 2008 12:51:32 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Kevin Winchester <kjwinchester@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Pavel Machek <pavel@ucw.cz>
References: <485AFC9B.7090502@gmail.com> <20080620101722.GD17692@elte.hu>
In-Reply-To: <20080620101722.GD17692@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806201251.33404.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 of June 2008, Ingo Molnar wrote:
> 
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
> > Hi,
> >
> > I am trying to track down a problem I reported here:
> >
> > http://lkml.org/lkml/2008/6/11/431
> 
>   [ GART related bootup crash. ]

Perhaps it's a good idea to bisect the GART branch of 'tip' alone, then.

Not that I think my patch in there could affect bootup, as it only sets some
variables during initialization.  Still, the other patches in there could.

Thanks,
Rafael
