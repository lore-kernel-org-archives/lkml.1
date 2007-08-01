Return-Path: <linux-kernel-owner+w=401wt.eu-S1761927AbXHAMXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761927AbXHAMXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764300AbXHAMXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:23:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41043 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764130AbXHAMXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:23:32 -0400
Date: Wed, 1 Aug 2007 13:28:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Neil Horman <nhorman@tuxdriver.com>, Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 1/3] coredump: cleanup documentation for suid_dumpable
Message-ID: <20070801132827.355c17e5@the-village.bc.nu>
In-Reply-To: <46AFF092.6050802@kernel.sg>
References: <20070731070238.GA2412@kernel.sg>
	<20070731070340.GB2412@kernel.sg>
	<20070731091337.5f3cb923@the-village.bc.nu>
	<46AFF092.6050802@kernel.sg>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > NAK - this feature is actively used and can be set by the sysctl
> > interface. The PRCTL fixup was just a bug being fixed. The sysctl
> > interface is still relevant.
> 
> Thank you for correcting me. Appreciated. I am not aware that it is still
> being actively used. May I know who or which program is using this feature?

Not programs - people. 

When you want to debug a large complex system with multiple setuid
applications it can rapidly get quite unpleasant. If you
set /proc/sys/kernel/suid_dumpable to 2 and /proc/sys/kernel/core_pattern
then it becomes possible to get hold of all the core dumps and debug the
system as a whole. The system is not secure in this state but while you
are doing that kind of debug on a devel system its usually acceptable.

Secondly we don't break userspace interfaces except in extreme cases -
proc/sys/kernel/suid_dumpable is a user space interface

Alan
