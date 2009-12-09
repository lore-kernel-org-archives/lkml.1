Return-Path: <linux-kernel-owner+w=401wt.eu-S967088AbZLIBP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967088AbZLIBP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 20:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967061AbZLIBP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 20:15:27 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:46393 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967036AbZLIBP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 20:15:27 -0500
Date: Tue, 8 Dec 2009 17:14:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: asm/hw_breakpoint.h header check failures...
Message-Id: <20091208171435.f43ad37b.randy.dunlap@oracle.com>
In-Reply-To: <20091208.153722.15444835.davem@davemloft.net>
References: <20091208.153722.15444835.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B1EFA30.003A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Dec 2009 15:37:22 -0800 (PST) David Miller wrote:

> 
> This is very strange, I never saw this error reported against
> -next all these past weeks yet I know they do build testing
> with this check enabled :-)
> 
> /home/davem/src/GIT/sparc-2.6/usr/include/linux/perf_event.h:22: included file 'asm-sparc/hw_breakpoint.h' is not exported
> make[3]: *** [/home/davem/src/GIT/sparc-2.6/usr/include/linux/.check] Error 123
> make[2]: *** [linux] Error 2
> make[1]: *** [headers_check] Error 2
> make: *** [vmlinux] Error 2
> --

Patch was posted yesterday:
http://lkml.org/lkml/2009/12/7/286

---
~Randy
