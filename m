Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbYJ2U5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbYJ2U5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYJ2U5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:57:02 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48708 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbYJ2U5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:57:00 -0400
Message-ID: <4908CE18.3030205@linux.vnet.ibm.com>
Date: Wed, 29 Oct 2008 15:56:56 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: stable@kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
Subject: 16G related patches for stable kernel 2.6.27
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider the following patches for the 2.6.27 stable tree.

The first two allow a powerpc machine with more then 2 numa nodes
to boot when 16G pages are enabled.  The third one allows a powerpc
machine to boot if using 16G pages and the mem= boot param.

thanks,
Jon


powerpc: Reserve in bootmem lmb reserved regions that cross NUMA nodes
    commit 8f64e1f2d1e09267ac926e15090fd505c1c0cbcb
powerpc/numa: Make memory reserve code more robust
    commit e81703724a966120ace6504c993bda9e084cbf3e
powerpc: Don't use a 16G page if beyond mem= limits
    commit 4792adbac9eb41cea77a45ab76258ea10d411173



