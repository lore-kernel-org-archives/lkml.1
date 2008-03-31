Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbYCaRWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbYCaRWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYCaRWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:22:47 -0400
Received: from mail.vyatta.com ([216.93.170.194]:53392 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbYCaRWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:22:46 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.499
Date: Mon, 31 Mar 2008 10:22:40 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: generic versions of find_first_(zero_)bit, convert
 i386
Message-ID: <20080331102240.086a93e4@extreme>
In-Reply-To: <20080331171506.GA24017@mailshack.com>
References: <20080331171506.GA24017@mailshack.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008 19:15:06 +0200
Alexander van Heukelum <heukelum@mailshack.com> wrote:

> Generic versions of __find_first_bit and __find_first_zero_bit
> are introduced as simplified versions of __find_next_bit and
> __find_next_zero_bit. Their compilation and use are guarded by
> a new config variable GENERIC_FIND_FIRST_BIT.
> 
> The generic versions of find_first_bit and find_first_zero_bit
> are implemented in terms of the newly introduced __find_first_bit
> and __find_first_zero_bit.
> 
> This patch also converts i386 to the generic functions. The text
> size shrinks slightly due to uninlining of the find_*_bit functions.
> 
>    text    data     bss     dec     hex filename
> 4764939  480324  622592 5867855  59894f vmlinux  (i386 defconfig before)
> 4764645  480324  622592 5867561  598829 vmlinux  (i386 defconfig after)
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 

Size isn't everything, what is the performance difference?
