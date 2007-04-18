Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXDRG6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXDRG6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 02:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXDRG6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 02:58:42 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:20743 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659AbXDRG6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 02:58:41 -0400
Message-ID: <4625C2A9.6010306@sw.ru>
Date: Wed, 18 Apr 2007 11:03:05 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Linux MM <linux-mm@kvack.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] Show slab memory usage on OOM and SysRq-M (v2)
References: <4624E8F4.2090200@sw.ru> <84144f020704172324u725f6b22u4b1634203d65167c@mail.gmail.com>
In-Reply-To: <84144f020704172324u725f6b22u4b1634203d65167c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On 4/17/07, Pavel Emelianov <xemul@sw.ru> wrote:
>> The out_of_memory() function and SysRq-M handler call
>> show_mem() to show the current memory usage state.
> 
> I am still somewhat unhappy about the spinlock, but I don't really

What's wrong with the spinlock? It exists there without my
patch, I just make ++/-- of unatomic variable under this lock :)

> have a better suggestion either. Other than that, looks good to me.
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 

