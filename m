Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbXJWRoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbXJWRoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXJWRnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:43:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbXJWRnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:43:52 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: Re: [PATCH 4/4] x86 gart: rename symbols only used for the GART implementation
Date: Tue, 23 Oct 2007 19:43:47 +0200
User-Agent: KMail/1.9.6
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <11931612933917-git-send-email-joerg.roedel@amd.com> <1193161293928-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1193161293928-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710231943.47157.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2007 19:41:33 Joerg Roedel wrote:
> This patch renames the 4 symbols iommu_hole_init(), iommu_aperture,
> iommu_aperture_allowed, iommu_aperture_disabled.
> 
> It replaces the iommu_ with gart_ in the symbol name. All these symbols are
> only used for the GART implementation of IOMMUs.

That makes it still potentially conflicting with the AGP GART code.

-Andi
