Return-Path: <linux-kernel-owner+w=401wt.eu-S1750713AbXBUAhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750713AbXBUAhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbXBUAhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:37:01 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:39194 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbXBUAhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:37:00 -0500
Message-ID: <45DB9429.20309@blueyonder.co.uk>
Date: Wed, 21 Feb 2007 00:36:57 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: IPV6 build failure 2.6.20-git1x
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 builds without errors on openSUSE 10.2.
x86 on openSUSE 10.3 Alpha1
 gcc version 4.1.2 20070115 (prerelease) (SUSE Linux)
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IP6_NF_MATCH_IPV6HEADER=m

  LD      arch/i386/lib/built-in.o
  CC      arch/i386/lib/bitops.o
  AS      arch/i386/lib/checksum.o
  CC      arch/i386/lib/delay.o
  AS      arch/i386/lib/getuser.o
  CC      arch/i386/lib/memcpy.o
  CC      arch/i386/lib/mmx.o
  AS      arch/i386/lib/putuser.o
  AS      arch/i386/lib/semaphore.o
  CC      arch/i386/lib/strstr.o
  CC      arch/i386/lib/usercopy.o
  AR      arch/i386/lib/lib.a
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
net/built-in.o: In function `svc_udp_recvfrom':
svcsock.c:(.text+0x91f9c): undefined reference to `__ipv6_addr_type'
make: *** [.tmp_vmlinux1] Error 1
:/usr/src/linux-2.6.20-git15

Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


