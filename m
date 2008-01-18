Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYARHKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYARHKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 02:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYARHKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 02:10:01 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:55481 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYARHKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 02:10:00 -0500
Message-ID: <479050BF.1090107@linux.vnet.ibm.com>
Date: Fri, 18 Jan 2008 12:39:51 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Sam Ravnborg <sam@ravnborg.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 build failure on headers_check
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails during the headers_check on power box

  CHECK   include/asm/nvram.h
/usr/local/autobench/autotest/tmp/build/linux/usr/include/asm/nvram.h requires linux/list.h, which does not exist in exported headers
make[3]: *** [/usr/local/autobench/autotest/tmp/build/linux/usr/include/asm/.check.nvram.h] Error 1
make[2]: *** [asm-powerpc] Error 2
make[1]: *** [headers_check] Error 2
make: *** [vmlinux] Error 2

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
