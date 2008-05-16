Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbYEPRGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbYEPRGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYEPRGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:06:11 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:36800 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYEPRGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:06:10 -0400
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: [RFC Patch 0/5] Modifying blktrace to use 'trace' infrastructure
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
Organization: IBM
Cc: dwilder@us.ibm.com, axboe@kernel.dk, linux-btrace@vger.kernel.org,
       akpm@linux-foundation.org, prasad@linux.vnet.ibm.com
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 16 May 2008 22:35:42 +0530
Message-ID: <op.ua9a3sz103j166@prasadkr_t60p.in.ibm.com>
User-Agent: Opera Mail/9.26 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please review the following set of patches which modify blktrace
to use trace_dump() function provided as a part of 'trace'
infrastructure.

This change brings amount huge amount of code savings i.e. ~130 lines of
code reduced in blktrace.c while retaining all existing functionality
provided by the blktrace application. This change in the kernel requires
no user-space code changes.

The patchset is based upon 2.6.25-mm1 and has been tested on an i386
machine.

The patchset contains five patches, most of which remove the code in
blktrace.c that have become redundant due to use of 'trace_dump()'.

Thanks,
K.Prasad

