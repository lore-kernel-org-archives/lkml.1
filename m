Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZDNVfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZDNVfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZDNVfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:35:22 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:59852 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZDNVfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:35:21 -0400
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: current->mm == NULL in security_vm_enough_memory().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp>
	<alpine.LRH.2.00.0903261236580.30336@tundra.namei.org>
	<200904092105.HBG52601.MHFOtQOLSVFOFJ@I-love.SAKURA.ne.jp>
	<200904132127.FBG30222.OOFFtQLJFOHSMV@I-love.SAKURA.ne.jp>
	<20090414164029.GC4791@suse.de>
In-Reply-To: <20090414164029.GC4791@suse.de>
Message-Id: <200904150635.DFG12409.QLFHMOSFFtVJOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 15 Apr 2009 06:35:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> > I'm experiencing
> > 
> >   WARNING: at security/security.c:217 security_vm_enough_memory+0xa0/0xb0()
> > 
> > messages.
> > "git bisect" reported that commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7
> > is the cause of this warning. May I ignore this warning?
> 
> I don't know, can you provide the full warning?
Yes. It is http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc1.txt

> And what kernel version is this happening on?
It is 2.6.30-rc1.
Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.30-rc1
