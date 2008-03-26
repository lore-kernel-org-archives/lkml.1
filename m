Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbYCZVUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbYCZVUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYCZVUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:20:34 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56765 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbYCZVUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:20:33 -0400
Message-ID: <47EABE2D.7080400@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2008 16:20:45 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Reply-To: kniht@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
CC: Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Adam Litke <agl@linux.vnet.ibm.com>
Subject: [PATCH 0/4] 16G huge page support for powerpc
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set builds on Andi Kleen's patches for GB pages for hugetlb
posted on March 16th.  This set adds support for 16G huge pages on
ppc64.  Supporting multiple huge page sizes on ppc64 as defined in
Andi's patches is not a part of this set; that will be included in a
future patch.

The first patch here adds an arch callback since the 16G pages are not
allocated from bootmem.  The 16G pages have to be reserved prior to
boot-time.  The location of these pages are indicated in the device tree.

Support for 16G pages requires a POWER5+ or later machine and a little
bit of memory.

Jon

