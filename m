Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbZHTLP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbZHTLP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZHTLP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:15:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:55730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbZHTLP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:15:57 -0400
Subject: Re: [PATCH] intel-iommu: Work around yet another BIOS bug
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, Faidon Liambotis <paravoid@debian.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090820024453.dd9909a2.akpm@linux-foundation.org>
References: <bug-14003-10286@http.bugzilla.kernel.org/>
	 <20090819142634.0fc550d1.akpm@linux-foundation.org>
	 <1250754748.8974.17.camel@macbook.infradead.org>
	 <1250755318.8974.26.camel@macbook.infradead.org>
	 <20090820024453.dd9909a2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 12:14:37 +0100
Message-Id: <1250766877.11523.1.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 02:44 -0700, Andrew Morton wrote:
> Printing a u64 with %ll will (still) generate a warning on four
> architectures.

Still that many? I thought we'd fixed them all already.

Certainly we fixed IA64, which is the last one I cared about in the
context of this particular code.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

