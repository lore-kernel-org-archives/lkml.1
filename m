Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZIISRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZIISRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbZIISRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:17:34 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2816 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbZIISRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:17:34 -0400
Message-ID: <4AA7F133.20104@caviumnetworks.com>
Date: Wed, 09 Sep 2009 11:17:23 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dok Sander <doksander@yahoo.com>
CC: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>
Subject: Re: io.h doesn't get installed by target "headers_install" for mips
References: <806810.23677.qm@web59313.mail.re1.yahoo.com>
In-Reply-To: <806810.23677.qm@web59313.mail.re1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2009 18:17:23.0636 (UTC) FILETIME=[C7340740:01CA3179]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dok Sander wrote:
> Hi,
> 
>  I noticed the absence of the header io.h while trying to build(cross-compile, host i686-pc-linux-gnu) a software(lm-sensors-3.1.1, wants io.h in /sys) for mips. I can find io.h for mips in arch/mips/asm/include/{,sn/} However, io.h doesn't get installed when i do "make ARCH=mips headers_install" on linux 2.6.30.6
> 
>  According to someone on the eglibc mailing list, linux should provide io.h for mips. Is this true?
> 

I don't think so (for two reasons):

1) The things in /usr/include/sys are provided by libc not the kernel.

2) MIPS doesn't have I/O ports, so all the functions in sys/io.h on an 
x86 are undefined for MIPS.

David Daney

