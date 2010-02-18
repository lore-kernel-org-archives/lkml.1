Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0BRIxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 03:53:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34641 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab0BRIxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 03:53:52 -0500
Date: Thu, 18 Feb 2010 08:53:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Kernel panic due to page migration accessing memory holes
Message-ID: <20100218085336.GB848@n2100.arm.linux.org.uk>
References: <4B7C8DC2.3060004@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7C8DC2.3060004@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 04:45:54PM -0800, Michael Bohan wrote:
> I have encountered a kernel panic on the ARM/msm platform in the mm  
> migration code on 2.6.29.  My memory configuration has two discontiguous  
> banks per our ATAG definition.   These banks end up on addresses that  
> are 1 MB aligned.  I am using FLATMEM (not SPARSEMEM), but my  
> understanding is that SPARSEMEM should not be necessary to support this  
> configuration.  Please correct me if I'm wrong.

Make sure you have ARCH_HAS_HOLES_MEMORYMODEL enabled.
