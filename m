Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbYAGIsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbYAGIsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbYAGIsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:48:35 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:39968 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754814AbYAGIse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:48:34 -0500
Message-ID: <4781E75B.3020307@linux.vnet.ibm.com>
Date: Mon, 07 Jan 2008 14:18:27 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.24-rc7 Build Failure on headers_install
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The make allyesconfig build fails on x86_64 (AMD box) with the following
error

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CHK     include/linux/version.h
make[2]: `scripts/unifdef' is up to date.
make[2]: *** No rule to make target `|', needed by `asm-generic'.  Stop.
make[1]: *** [headers_install] Error 2
make: *** [vmlinux] Error 2

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
