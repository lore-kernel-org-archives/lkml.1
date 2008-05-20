Return-Path: <linux-kernel-owner+w=401wt.eu-S934029AbYETVLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029AbYETVLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760397AbYETVLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:11:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44863 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759593AbYETVLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:11:09 -0400
Date: Tue, 20 May 2008 17:11:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Subject: Re: Compile warning rtmutex code on 2.6.24.7-rt8 (CC:LKML added)
In-Reply-To: <3efb10970805201356x4552859bof5f3f4f56f2ba676@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0805201707210.20474@gandalf.stny.rr.com>
References: <3efb10970805201356x4552859bof5f3f4f56f2ba676@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 May 2008, Remy Bohmer wrote:

> Hello Steven,
>
>  Do you recognise these warnings? I do not know (yet) if these are ARM
>  specific...
>
>   CC      kernel/rtmutex.o
>  kernel/rtmutex.c: In function 'rt_write_fastlock':
>  kernel/rtmutex.c:1582: warning: initialization makes pointer from
>  integer without a cast
>  kernel/rtmutex.c: In function 'rt_write_fasttrylock':
>  kernel/rtmutex.c:1622: warning: initialization makes pointer from
>  integer without a cast
>
>  If so, do you have a fix for it?

Ah, I guess ARM is a bit more critical of chpxchg than x86 is.

I'll add a patch for 2.6.24.7-rt9 (which I plan on releasing soon). It
will have some minor clean ups.

-- Steve

