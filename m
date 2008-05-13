Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbYEMRH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbYEMRH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYEMRHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:07:21 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47391 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYEMRHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:07:20 -0400
Message-ID: <4829CAC3.30900@us.ibm.com>
Date: Tue, 13 May 2008 12:07:15 -0500
From: Jon Tollefson <kniht@us.ibm.com>
Reply-To: kniht@linux.vnet.ibm.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
CC: Paul Mackerras <paulus@samba.org>, Nick Piggin <npiggin@suse.de>,
       Nishanth Aravamudan <nacc@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Adam Litke <agl@us.ibm.com>
Subject: [PATCH 0/6] 16G and multi size hugetlb page support on powerpc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set builds on Nick Piggin's patches for multi size and giant 
hugetlb page support of April 22.  The following set of patches adds 
support for 16G huge pages on ppc64 and support for multiple huge page 
sizes at the same time on ppc64.  Thus allowing 64K, 16M, and 16G huge 
pages given a POWER5+ or later machine.

New to this version of my patch is numerous bug fixes and cleanups, but 
the biggest change is the support for multiple huge page sizes on power.

patch 1: changes to generic hugetlb to enable 16G pages on power
patch 2: powerpc: adds function for allocating 16G pages
patch 3: powerpc: setups 16G page locations found in device tree
patch 4: powerpc: page definition support for 16G pages
patch 5: check for overflow when user space is 32bit
patch 6: powerpc: multiple huge page size support

Jon


