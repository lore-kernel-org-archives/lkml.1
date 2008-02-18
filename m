Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbYBRVUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbYBRVUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYBRVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:20:46 -0500
Received: from mail-09.jhb.wbs.co.za ([196.2.97.6]:16228 "EHLO
	mail-09.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYBRVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:20:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAI+FuUfEAmHEgWdsb2JhbACQVgEBCQoPGpxr
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
Date: Mon, 18 Feb 2008 23:20:40 +0200
User-Agent: KMail/1.9.8
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <200802171036.19619.bonganilinux@mweb.co.za> <20080218131125.2857f7c7@gaivota>
In-Reply-To: <20080218131125.2857f7c7@gaivota>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802182320.40732.bonganilinux@mweb.co.za>
X-Original-Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
X-Scan-Signature: d01de2f6305d17f197ee837eb9042209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008 18:11:25 Mauro Carvalho Chehab wrote:
> On Sun, 17 Feb 2008 10:36:19 +0200
>
> Bongani Hlope <bonganilinux@mweb.co.za> wrote:
> > The bttv driver seems to be experiencing problems in the 2.6.25-rcX
> > kernels. I have the divided by error that  Robert Fitzsimons has already
> > reported (I'll test his patch and see if it fixes it for me) and I have
> > the following Oops when I try to use the radio:
>
> Have you tested Robert's patch?
>

Sorry almost forgot, I have and it fixes the TV but not the radio.

> I can't see anything wrong on bttv_g_tuner lock. I suspect that the divide
> error caused some bad effects at some data on bttv.
>

 The problems don't seem related because one is caused by opening the "radio" 
application, the divide error is caused by using a TV viewing application (I 
tried fbtv)

> I've already applied his fix to my -git tree:

Thanx, I'll try to bisect

>
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git
>
> Hopefully, Linus will pull soon the fixes there.
>
