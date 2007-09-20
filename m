Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbXITGue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbXITGue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbXITGu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:50:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXITGu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:50:26 -0400
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Howard Chu <hyc@symas.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MTRR initialization
References: <46EAB7DA.10507@symas.com>
	<200709191452.57505.jesse.barnes@intel.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Sep 2007 08:50:23 +0200
In-Reply-To: <200709191452.57505.jesse.barnes@intel.com>
Message-ID: <p73d4wdal00.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jesse.barnes@intel.com> writes:
> 
> To do this in a nicer way (and be less vulnerable to similar BIOS 
> funkiness) the kernel really needs full PAT support.  That should allow 
> WC over WB and WC over UC mappings to occur, at least if I'm 
> remembering the docs right...

PAT only really helps for device driver performance optimizations.
But if the basic WB MTRRs are wrong PAT cannot really salvage it. 

-Andi
