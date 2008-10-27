Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYJ0JTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYJ0JTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYJ0JS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:18:58 -0400
Received: from gw.goop.org ([64.81.55.164]:36908 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbYJ0JS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:18:57 -0400
Message-ID: <49058774.3030506@goop.org>
Date: Mon, 27 Oct 2008 20:18:44 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, jens.axboe@oracle.com
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with BIOVEC_PHYS_MERGEABLE
References: <4902371A.5050303@goop.org>	<20081027125139I.fujita.tomonori@lab.ntt.co.jp>	<49057A15.7030007@goop.org> <20081027173739Q.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081027173739Q.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> I'm not familiar with what Xen does but why can't Xen just override
> BIOVEC_PHYS_MERGEABLE?
>
> Why does Xen need to hook BIOVEC_PHYS_MERGEABLE to the iommu_bio_merge
> parameter (as this patch does)? BIOVEC_PHYS_MERGEABLE and the
> iommu_bio_merge parameter are not related at all.
>   

No, it doesn't.  It was convenient to reuse that mechanism, but I can 
easily re-add something else (which would be more or less identical).

    J

