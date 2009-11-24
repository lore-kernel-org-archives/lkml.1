Return-Path: <linux-kernel-owner+w=401wt.eu-S933894AbZKXSaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894AbZKXSaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933785AbZKXSaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:30:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:43287 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933085AbZKXSaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:30:04 -0500
Message-ID: <4B0C25E7.2040806@kernel.org>
Date: Tue, 24 Nov 2009 10:28:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix gart iommu using for amd 64 bit system
References: <4B0BAC06.1000905@kernel.org> <20091124193031P.fujita.tomonori@lab.ntt.co.jp> <4B0BB892.9080401@kernel.org> <20091124225000H.fujita.tomonori@lab.ntt.co.jp> <20091124152645.GD21821@elte.hu>
In-Reply-To: <20091124152645.GD21821@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
>>> don't think user will like to use SWIOTLB instead of swiotlb.
>> I doubt that users care about a way to fix their problems.
> 
> As far as swiotlb vs. GART goes, arguably a non-bouncing hw based 
> solution (GART) is superior to a bouncing one (swiotlb), right?
> 

yes, should use GART if possible.

YH
