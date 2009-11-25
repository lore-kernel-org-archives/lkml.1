Return-Path: <linux-kernel-owner+w=401wt.eu-S934619AbZKYJGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619AbZKYJGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934496AbZKYJGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:06:32 -0500
Received: from sh.osrg.net ([192.16.179.4]:48823 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934548AbZKYJGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:06:31 -0500
Date: Wed, 25 Nov 2009 18:05:47 +0900
To: yinghai@kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B0CF0CA.30807@kernel.org>
References: <4B0C7257.3070609@kernel.org>
	<20091125081832.GA1822@elte.hu>
	<4B0CF0CA.30807@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091125180517P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 25 Nov 2009 18:05:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 00:54:34 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> only remember that SLES 9 SP3 (?) at some point has problem with AMD 10h ( quad core version)
> when memory > 4 g (with USB controller ?)
> because the gart code only check K8 device id, and didn't check 10h device id. so gart iommu is not used.
> and happenly swiotlb code has problem with that kernel version.
> 
> thinking we should keep old behavior, until some day we can remove them all.

Why? We are talking about changing 2.6.33 behavior. swiotlb in 2.6.33
should be the safe option.
