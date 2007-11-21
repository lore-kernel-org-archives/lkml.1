Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbXKUIzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbXKUIzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbXKUIyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:54:52 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:52850 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbXKUIyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:54:50 -0500
Message-ID: <4743E706.6010504@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2007 13:36:30 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc3-mm1- powerpc link failure
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
In-Reply-To: <20071120204525.ff27ac98.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails on powerpc while linking,

  AS      .tmp_kallsyms3.o
  LD      vmlinux.o
ld: TOC section size exceeds 64k
make: *** [vmlinux.o] Error 1

The patch posted at http://lkml.org/lkml/2007/11/13/414, solves this 
failure.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
