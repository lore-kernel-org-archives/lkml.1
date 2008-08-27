Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYH0PTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYH0PTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbYH0PTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:19:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:8901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbYH0PTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:19:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,279,1217833200"; 
   d="scan'208";a="329588318"
Message-ID: <48B57074.40201@linux.intel.com>
Date: Wed, 27 Aug 2008 17:19:16 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: bjorn.helgaas@hp.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       linux-acpi@vger.kernel.org, ckornacker@suse.de
Subject: Re: Introduce interface to report BIOS bugs (reworked, FW_BUG simple
 solution)
References: <200808210919.07642.bjorn.helgaas@hp.com> <1219843631-26015-1-git-send-email-trenn@suse.de>
In-Reply-To: <1219843631-26015-1-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
> Even simplier, using FW_BUG define. I agree that the first implementation
> was over-designed, I somehow liked the printk_fw_err() and printk_fw_info()
> more, looked somehow more consistent with:

Looks good to me now. The only issue is that the patchkit is cross subsystem
(cpufreq and ACPI). Either the patches go in through Andrew or we need
to figure out how to merge this.
-Andi
