Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYCVVFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYCVVFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYCVVF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:05:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYCVVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:05:26 -0400
Message-ID: <47E57393.7060606@zytor.com>
Date: Sat, 22 Mar 2008 14:01:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: yhlu.kernel@gmail.com, yhlu.kernel.send@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
References: <200803202358.33722.yhlu.kernel@gmail.com> <20080322134814.7258ff0c@laptopd505.fenrus.org>
In-Reply-To: <20080322134814.7258ff0c@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 20 Mar 2008 23:58:33 -0700
> Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
> 
>> do simple memtest after init_memory_mapping
>>
>> use find_e820_area_size to find all ram range that is not reserved.
> 
> be careful, there's some special memory that e820 right now says is not reserved,
> but still has bios data (the first 4Kb of memory come to mind)
> 

Is that true even after Yinghai's changes?  I have lost track of all the 
patches...

	-hpa
