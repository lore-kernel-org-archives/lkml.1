Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbXHAXRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbXHAXRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXHAXRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:17:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:46769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbXHAXRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:17:04 -0400
Date: Thu, 2 Aug 2007 01:17:03 +0200
From: Olaf Hering <olh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22: oops in sbp2_remove_device
Message-ID: <20070801231703.GA25672@suse.de>
References: <20070801175718.GA19589@suse.de> <tkrat.f4fe19cd6ad9843d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tkrat.f4fe19cd6ad9843d@s5r6.in-berlin.de>
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, Stefan Richter wrote:

> Revert commit 0555659d63c285ceb7ead3115532e1b71b0f27a7 from 2.6.22-rc1.
> The dma_set_mask call somehow failed on a PowerMac G5, PPC64:
> http://lkml.org/lkml/2007/8/1/344

This change fixes the oops, and I can access the drive again.
