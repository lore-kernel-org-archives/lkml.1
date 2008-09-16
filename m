Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYIPAyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYIPAyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 20:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYIPAyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 20:54:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48252 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbYIPAyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 20:54:35 -0400
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about virtual mappings
From: Andi Kleen <andi@firstfloor.org>
References: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 16 Sep 2008 02:54:32 +0200
In-Reply-To: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> (FUJITA Tomonori's message of "Fri, 12 Sep 2008 19:42:32 +0900")
Message-ID: <87hc8grjuf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

> Currently, gart IOMMU ignores device's dma_mask when it does virtual
> mappings. So it could give a device a virtual address that the device
> can't access to.

Huh? That is what the need_iommu() logic in gart_map_sg()
does. An I'm not aware of any bugs in this area.

Did you actually see that failure in practice? I don't see
how it could happen.

-Andi
-- 
ak@linux.intel.com
