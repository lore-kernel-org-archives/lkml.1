Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZHIPQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZHIPQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 11:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZHIPQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 11:16:45 -0400
Received: from relay7.uol.com.br ([187.17.116.5]:52307 "EHLO relay7.uol.com.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbZHIPQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 11:16:45 -0400
Date: Sun, 9 Aug 2009 12:14:58 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Subject: Confusing help regarding single-depth WCHAN output
Message-ID: <20090809151458.GA32444@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SIG5: 5ba9331d6c67fa58d75a351bcde8bdea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I noticed this some releases ago, but only now I was perusing the kernel
with a little more attention and got very curious. When doing a "make
menuconfig" on an amd64 system, I get the following message:

,----
| Single-depth WCHAN output
| CONFIG_SCHED_OMIT_FRAME_POINTER:
| 
|  Calculate simpler /proc/<PID>/wchan values. If this option
|  is disabled then wchan values will recurse back to the
|  caller function. This provides more accurate wchan values,
|  at the expense of slightly more scheduling overhead.
| 
|  If in doubt, say "Y".
| 
|  Symbol: SCHED_OMIT_FRAME_POINTER [=y]
|  Prompt: Single-depth WCHAN output
|    Defined at arch/x86/Kconfig:441
|    Depends on: X86
|    Location:
|      -> Processor type and features
`----

Is the WCHAN option related to omitting a frame pointer? If yes, how
could this be written in a more detailed way?


Thanks for any comments, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
