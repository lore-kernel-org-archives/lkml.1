Return-Path: <linux-kernel-owner+w=401wt.eu-S933391AbXBETV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbXBETV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933400AbXBETV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:21:27 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:12502 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391AbXBETVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:21:25 -0500
In-Reply-To: <Pine.LNX.4.64.0702051040160.14453@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <87DE673C-92A0-4401-8DE5-BDC2C08B5F41@oracle.com> <Pine.LNX.4.64.0702051040160.14453@alien.or.mcafeemobile.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B8027EC7-79FA-485B-89AB-87009CA20E40@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Mon, 5 Feb 2007 14:20:31 -0500
To: Davide Libenzi <davidel@xmailserver.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Or we need some sort of enter_context()/leave_context() (adopt mm,  
> files,
> ...) to have a per-CPU kthread to be able to execute the syscall  
> from the
> async() caller context.

I believe that's what Ingo is hoping for, yes.

- z
