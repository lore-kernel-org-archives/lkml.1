Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZBEFo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZBEFo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 00:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZBEFoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 00:44:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52096 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZBEFoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 00:44:19 -0500
Message-ID: <498A7BE3.40405@zytor.com>
Date: Wed, 04 Feb 2009 21:40:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: __supported_pte_mask breaks PROT_NONE pages
References: <498A5002.9080408@goop.org>
In-Reply-To: <498A5002.9080408@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dropped wli from the Cc: list because holomorphy.com doesn't resolve]

Jeremy Fitzhardinge wrote:
> 
> I guess the best fix is to only apply __supported_pte_mask to present
> ptes.  This seems like the right solution to me, as it means we can
> completely ignore the issue of overlaps between the present pte bits and
> the non-present pte-as-swap entry use of the bits.  (Patch below.)
> 

It certainly looks reasonable, so I have applied this patch to
tip:x86/urgent.  However, since I'm on the way out to FOSDEM I won't be
able to run any tests on this.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

