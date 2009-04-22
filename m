Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZDVWFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZDVWFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZDVWF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:05:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:63820 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbZDVWFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:05:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,232,1239001200"; 
   d="scan'208";a="509018952"
Date: Wed, 22 Apr 2009 15:04:48 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86/pci: fix -1 calling to e820_all_mapped with
 mmconfig
Message-ID: <20090422150448.2ff44fcb@hobbes>
In-Reply-To: <49E992C2.4010707@kernel.org>
References: <49E992C2.4010707@kernel.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009 01:43:46 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> e820_all_mapped need end is (addr + size) instead of (addr + size - 1)
> 
> [Impact: fix -1 offset calling]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
