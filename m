Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbYBAUEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbYBAUEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbYBAUED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:04:03 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:40601 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbYBAUEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:04:02 -0500
Date: Fri, 01 Feb 2008 12:21:44 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] make loglevel related commandline to early_param v2
In-reply-to: <20080201115623.c9f1c85b.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, andi@firstfloor.org, linux-kernel@vger.kernel.org
Message-id: <200802011221.44741.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802010240.37799.yinghai.lu@sun.com>
 <200802011135.36475.yinghai.lu@sun.com>
 <20080201115623.c9f1c85b.akpm@linux-foundation.org>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 11:56:23 am Andrew Morton wrote:
> On Fri, 01 Feb 2008 11:35:35 -0800
> Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > [PATCH] make loglevel related commandline to early_param v2
> > 
> > so we can use them for early console like 
> > console=uart8250,io,0x3f8,115200n8
> > earlycon=uart8250,io,0x3f8,115200n8
> > early_printk
> > 
> > otherwise printk(KERN_DEBUG "debug msg") will not print out to console even
> > "debug" command line is used.
> > 
> > andi point out early_param need to return 0 instead 1.
> > 
> > Ingo had another patch in x86.git to process ignore_loglevel
> > 
...
> 
> Your earlier patch converted ignore_loglevel but this one no longer does
> so.  Was that deliberate?

Ingo put one process "ingore_logleve" in x86.git last night. 

YH
