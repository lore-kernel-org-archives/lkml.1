Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZJVSve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZJVSve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 14:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZJVSvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 14:51:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36121 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbZJVSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 14:51:33 -0400
Date: Thu, 22 Oct 2009 19:51:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-mmc@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: msm_sdcc.c: add missing include
Message-ID: <20091022185126.GA4401@n2100.arm.linux.org.uk>
References: <20091022072119.GA3285@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022072119.GA3285@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 09:21:19AM +0200, Pavel Machek wrote:
> 
> Add missing include for	msm_sdcc compilation.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

I don't think this is the right solution - why should MSM have a
platform specific include in the ARM generic include files?

(If anything, we should be getting rid of any non-shared platform
specific includes in the arch/arm/include/asm/mach directory.)
