Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbZB0VC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbZB0VC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbZB0VCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:02:48 -0500
Received: from gw.goop.org ([64.81.55.164]:60419 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbZB0VCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:02:47 -0500
Message-ID: <49A854ED.7020401@goop.org>
Date: Fri, 27 Feb 2009 13:02:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: add brk allocation for very, very early allocations
References: <49A829CE.9020509@goop.org> <49A84C5A.3020304@kernel.org>
In-Reply-To: <49A84C5A.3020304@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> it seems reserve _brk_end is some late?
>
> init_memory_mapping(0,...) could get some for direct mapping page table. and it could start from _end...
>   

Ah, thanks!  I was confused by the use of reserve_early() in 
initmem_init(), but they're OK because they allocate out of the e820 map 
at that point (and init_memory_mapping() reserves everything it allocates).

I'll give it a whirl.

    J
