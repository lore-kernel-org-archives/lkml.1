Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752774AbYLRQtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbYLRQtz (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYLRQtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:49:33 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:24021 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYLRQtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:49:32 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] x86 gart: don't complain if no AMD GART found
Date: Thu, 18 Dec 2008 09:49:27 -0700
User-Agent: KMail/1.9.10
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, linux-kernel@vger.kernel.org
References: <20081217195234.13603.96737.stgit@bob.kio> <20081217202724.GB9475@redhat.com>
In-Reply-To: <20081217202724.GB9475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812180949.28042.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2008 01:27:24 pm Dave Jones wrote:
> On Wed, Dec 17, 2008 at 12:52:34PM -0700, Bjorn Helgaas wrote:
>  > It's perfectly normal for no AMD GART to be present, e.g., if you have
>  > Intel CPUs.
> 
> Yes! That's annoyed me for some time too.
> 
>  >  None of the other iommu_init() functions makes noise when
>  > it finds nothing.
>  
> The Calgary stuff is pretty noisy in the face of non-existant hardware too.
> Makes for noisy distro kernels..
> 
> Calgary: detecting Calgary via BIOS EBDA area
> Calgary: Unable to locate Rio Grande table in EBDA - bailing!

Yeah, I considered removing that, too.  At least the Calgary stuff
is KERN_DEBUG, so it's not quite as visible.  But I'm in favor of
removing it anyway.

Bjorn
