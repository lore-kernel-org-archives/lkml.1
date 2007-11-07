Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbXKGRNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbXKGRNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbXKGRNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:13:09 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47683 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbXKGRNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:13:08 -0500
Subject: Re: [Patch] Allocate sparse vmemmap block above 4G
From: Dave Hansen <haveblue@us.ibm.com>
To: Zou Nan hai <nanhai.zou@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Suresh.b.siddha@intel.com
In-Reply-To: <1194419267.3046.1412.camel@linux-znh>
References: <1194419267.3046.1412.camel@linux-znh>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 09:12:30 -0800
Message-Id: <1194455550.7078.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-07 at 15:07 +0800, Zou Nan hai wrote:
> Try to allocate sparse vmemmap block above 4G on x64 system.
> 
> On some single node x64 system with huge amount of physical memory e.g
> 64G. the memmap size maybe very big. 

Could we just change the default bootmem behavior to allocate top-down?

-- Dave

