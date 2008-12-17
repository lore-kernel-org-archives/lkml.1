Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752469AbYLRQkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbYLRQkY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYLRQkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:40:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42634 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYLRQkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:40:06 -0500
Date: Wed, 17 Dec 2008 15:27:24 -0500
From: Dave Jones <davej@redhat.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 gart: don't complain if no AMD GART found
Message-ID: <20081217202724.GB9475@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	iommu@lists.linux-foundation.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
	linux-kernel@vger.kernel.org
References: <20081217195234.13603.96737.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217195234.13603.96737.stgit@bob.kio>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 12:52:34PM -0700, Bjorn Helgaas wrote:
 > It's perfectly normal for no AMD GART to be present, e.g., if you have
 > Intel CPUs.

Yes! That's annoyed me for some time too.

 >  None of the other iommu_init() functions makes noise when
 > it finds nothing.
 
The Calgary stuff is pretty noisy in the face of non-existant hardware too.
Makes for noisy distro kernels..

Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!

	Dave

-- 
http://www.codemonkey.org.uk
