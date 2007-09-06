Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbXIFTqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbXIFTqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 15:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbXIFTqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 15:46:35 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:60911 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755478AbXIFTqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 15:46:34 -0400
Date: Thu, 6 Sep 2007 15:46:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: hpa@zytor.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Warning about init section reference in start_kernel (2.6.23-rc4-mm1)
Message-ID: <20070906194632.GB4518@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:41:57 up 38 days, 20:00,  5 users,  load average: 0.51, 1.02, 0.89
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I have seen the following warning on the recent -mm kernels when
compiling a i386 kernel:

  scripts/mod/modpost   -o /home/compudj/git/morestable/linux-2.6-lttng/Module.symvers    vmlinux.o
WARNING: vmlinux.o(.text.head+0x223): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')

It looks like head.S jumps to start_kernel at the end of is386. Is this
ok and valid ? If yes, then I guess modpost should be updated.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
