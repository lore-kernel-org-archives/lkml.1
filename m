Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701Ab0ADRtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab0ADRtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367Ab0ADRti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:49:38 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:52755 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab0ADRti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:49:38 -0500
Date: Mon, 4 Jan 2010 11:48:34 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, "\"Yinghai Lu" <yingai@kernrel.org>
Subject: Re: [PATCH -v2 0/25] x86: use early_res instead of bootmem before
 slab
In-Reply-To: <1261525263-13763-1-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001041147240.7191@router.home>
References: <1261525263-13763-1-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, Yinghai Lu wrote:

> From: "Yinghai Lu <yingai@kernrel.org>"
>
> please check the patches regarding with early_res and bootmem
>
> and at last it will make use early_res instead of bootmem with x86 64bits
>
> the first two are needed for some amd_bus.c/intel_bus.c cleaning up patches too.
> so put other x86/pci related into this series
> hope that is ok to Jesse.
>
> -v2: allocate vmemmap on one node together, and also seperate early_res

The point of this patchset is what?

Avoid use of bootmem altogether by x86 bootstrap? If so why?


