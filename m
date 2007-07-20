Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbXGTU2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbXGTU2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbXGTU2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:28:12 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:61451 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758828AbXGTU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:28:11 -0400
Date: Fri, 20 Jul 2007 16:28:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: tonyko@lineo.ca, robin.getz@analog.com
Cc: linux-kernel@vger.kernel.org
Subject: blackfin - cmpxchg not atomic ?
Message-ID: <20070720202807.GA15009@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:23:52 up 3 days, 14:57,  3 users,  load average: 0.69, 0.49, 0.41
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am currently passing through each architectures adding a
cmpxchg_local() to each system.h, and I notice that you disable
interrupts in your cmpxchg() implementation, why are you doing so ?
Also, does you assembly stub _really_ modify memory atomically ? If yes,
then there should be no need for disabling interrupts. Else, I see a
major problem with SMP.

I also don't like the comment in asm-blackfin/atomic.h :

 * Generally we do not concern about SMP BFIN systems, so we don't have
 * to deal with that.

I have seen on the blackfin website that you actually sell a board with
SMP. Why aren't you caring about it ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
