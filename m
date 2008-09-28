Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYI1SHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYI1SHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 14:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYI1SHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 14:07:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:35930 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbYI1SHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 14:07:24 -0400
Date: Mon, 29 Sep 2008 03:06:40 +0900
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for
	GART
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080927181855.GA11147@elte.hu>
References: <20080925104212.GA27928@amd.com>
	<20080927181438.GF1108@elte.hu>
	<20080927181855.GA11147@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080929030640X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Sep 2008 20:18:55 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> another thing:
> 
> How hard would it be to add an CONFIG_IOMMU_DEBUG option that forces as 
> many DMA requests to go via the IOMMU as possible?
> 
> This slows things down of course so it's only for debugging - but it 
> also makes sure that we utilize the IOMMU code to the maximum - which is 
> not normally the case.

If you use iommu=force boot option, GART always tries to use the
IOMMU.
