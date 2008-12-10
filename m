Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYLJTUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYLJTUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYLJTUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:20:21 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55605 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbYLJTUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:20:21 -0500
Subject: Re: [PATCH 12/15] kmemleak: Enable the building of the memory leak
	detector
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081210182800.30323.49209.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182800.30323.49209.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 11:20:17 -0800
Message-Id: <1228936817.9737.102.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 18:28 +0000, Catalin Marinas wrote:
> +config DEBUG_MEMLEAK
> +       bool "Kernel memory leak detector"
> +       default n
> +       depends on EXPERIMENTAL
> +       select DEBUG_SLAB if SLAB
> +       select SLUB_DEBUG if SLUB
> +       select DEBUG_FS
> +       select STACKTRACE
> +       select FRAME_POINTER
> +       select KALLSYMS

So, not all architectures have STACKTRACE or FRAME_POINTER.  I think a
few of these should at least be done with depends.

Is this feature accessible if DEBUG_FS=n?  It seems to compile OK, but I
wonder if it is useful.

-- Dave

