Return-Path: <linux-kernel-owner+w=401wt.eu-S965316AbZLHAwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965316AbZLHAwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965307AbZLHAwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:52:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:38828 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965288AbZLHAwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:52:33 -0500
Message-ID: <4B1DA310.7050408@kernel.org>
Date: Mon, 07 Dec 2009 16:51:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
References: <20091202162510Q.fujita.tomonori@lab.ntt.co.jp>	<4B161D70.3030301@kernel.org>	<20091202170715K.fujita.tomonori@lab.ntt.co.jp> <20091208092438Z.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091208092438Z.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 2 Dec 2009 17:07:24 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
>> On Tue, 01 Dec 2009 23:55:28 -0800
>> Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>>>>>> amd 64 systems that
>>>>>>> 1. do not have  AGP
>>>>>>> 2. do not have IOMMU
>>>>>>> 3. mem > 4g
>>>>>>> 4. BIOS do not allocate  correct gart in NB.
>>>>>>> will leave them to use SWIOTLB forcely.
>>>>>> As I asked earlier, can you tell me what dma ops such system is
>>>>>> supposed to use?
>>>>> gart_dma_ops
>>>> How does gart_dma_ops work on systems without IOMMU?
>>> ?
>> If a system doesn't have IOMMU, what does gart_dma_ops do?
> 
> Ping?

gart can do hw translation...

YH
