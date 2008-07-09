Return-Path: <linux-kernel-owner+w=401wt.eu-S1751158AbYGIQID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158AbYGIQID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbYGIQHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:07:53 -0400
Received: from gw.goop.org ([64.81.55.164]:57531 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbYGIQHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:07:52 -0400
Message-ID: <4874E24E.1060700@goop.org>
Date: Wed, 09 Jul 2008 09:07:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [patch] xen64: fix build error on 32-bit + !HIGHMEM 
References: <patchbomb.1215554782@localhost> <20080709111219.GA24874@elte.hu> <20080709114730.GA15238@elte.hu>
In-Reply-To: <20080709114730.GA15238@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> another small build fixlet, on 32-bit.
>
> 	Ingo
>
> ---------------->
> commit c3d03b62eb73cb66415b7bb3031981c6a0cb90c3
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Jul 9 13:45:33 2008 +0200
>
>     xen64: fix build error on 32-bit + !HIGHMEM
>     
>     fix:
>     
>     arch/x86/xen/enlighten.c: In function 'xen_set_fixmap':
>     arch/x86/xen/enlighten.c:1127: error: 'FIX_KMAP_BEGIN' undeclared (first use in this function)
>     arch/x86/xen/enlighten.c:1127: error: (Each undeclared identifier is reported only once
>     arch/x86/xen/enlighten.c:1127: error: for each function it appears in.)
>     arch/x86/xen/enlighten.c:1127: error: 'FIX_KMAP_END' undeclared (first use in this function)
>     make[1]: *** [arch/x86/xen/enlighten.o] Error 1
>     make: *** [arch/x86/xen/enlighten.o] Error 2
>     
>     FIX_KMAP_BEGIN is only available on HIGHMEM.
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>   

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
