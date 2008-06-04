Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbYFDRZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbYFDRZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYFDRZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:25:09 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:17942 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYFDRZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:25:08 -0400
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mgross@linux.intel.com,
       linux-scsi@vger.kernel.org
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
From: Andi Kleen <andi@firstfloor.org>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 04 Jun 2008 18:56:35 +0200
In-Reply-To: <20080604235053K.fujita.tomonori@lab.ntt.co.jp> (FUJITA Tomonori's message of "Wed, 4 Jun 2008 23:47:01 +0900")
Message-ID: <873antuojg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Jun 2008 17:17:34.0737 (UTC) FILETIME=[E1350010:01C8C666]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
>
> I'm just interested in other people's opinions on IOMMU
> implementations, performances, possible future changes for performance
> improvement, etc.

I think using the bitmap is an excellent idea and your numbers look good. 
Do you have numbers on the memory consumption too?
Trading some memory for performance is ok for something as performance critical 
as the IOMMU. 

-Andi
