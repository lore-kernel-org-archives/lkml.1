Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbXLLSqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbXLLSqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbXLLSp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:45:58 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:51951 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbXLLSp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:45:57 -0500
Date: Wed, 12 Dec 2007 13:45:52 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: should all THREAD_SIZE macros be defined in thread_info.h headers?
Message-ID: <alpine.LFD.0.9999.0712121342020.28488@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  just asking, given that:

include/asm-x86/page_64.h:#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
include/asm-arm/page-nommu.h:#define KTHREAD_SIZE (8192)
include/asm-arm/page-nommu.h:#define KTHREAD_SIZE PAGE_SIZE
include/asm-cris/processor.h:#define THREAD_SIZE       PAGE_SIZE
include/asm-m32r/processor.h:#define THREAD_SIZE (2*PAGE_SIZE)
include/asm-m68k/page.h:#define THREAD_SIZE (8192)

  all other arches seem to define that in their respective
thread_info.h headers.

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
