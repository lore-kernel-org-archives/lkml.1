Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbYGCVvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbYGCVvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYGCVvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:51:12 -0400
Received: from gw.goop.org ([64.81.55.164]:60521 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbYGCVvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:51:11 -0400
Message-ID: <486D49C7.5070702@goop.org>
Date: Thu, 03 Jul 2008 14:51:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, xen-ia64-devel@lists.xensource.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] xen: compilation fix for ia64 support.
References: <20080703070952.GB15683%yamahata@valinux.co.jp>
In-Reply-To: <20080703070952.GB15683%yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> don't include asm/pvclock-abi.h directly, but asm/xen/pvclock-abi.h
> At this moment linux ia64 won't accept asm/pvclock-abi.h because
> there's no user of it.

Huh?  Is this a ia64 maintainer policy?  Aren't you about to start using it?

>  Instead make it include asm/xen/pvclock-abi.h
> and create asm-x86/xen/pvclock-abi.h which includes asm-x86/pvclock-abi.h.
>   

I'm not very keen on crufting up asm-x86/xen/ for the ia64 code.  
Couldn't you have an asm-ia64/xen/pvclock-abi.h which includes 
<asm-x86/pvclock-abi.h>?

    J
