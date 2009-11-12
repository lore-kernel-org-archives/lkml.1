Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZKLUzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZKLUzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZKLUy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:54:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:16392 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbZKLUy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:54:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ylt8sG3TZHMY+ZbKVRw0B4YqqQOaVxJ6pzhFvqYDJi1j4gqn0uFvNipxSnm5I1yKhy
         ykqOhPYpgADZaaF8Nw8PceX5FMLLRWjXukj3nSYQtjo5H9or3iIZnnEaVjDvOQx9CQR4
         kalqpzb5EmXKYBWVY3Rpcnjf+/DUpez05HHto=
Date: Thu, 12 Nov 2009 23:54:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yinghai@kernel.org>, x86team <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,io-apic: Do not map IO-APIC direct registers
	twice
Message-ID: <20091112205459.GC5728@lenovo>
References: <20091112204852.GB5728@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112204852.GB5728@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 11:48:52PM +0300, Cyrill Gorcunov wrote:
> Please review, I didn't manage to test (emulate actually since I don't
> have such a hardware) it yet (going to do so this weekend).
> 
> Meanwhile I would like to heard comments, complains and etc...
> Perhaps I miss something obvious so don't hesitate to poke me.
> 
> 	-- Cyrill
> ---
> x86,io-apic: Do not map IO-APIC direct registers twice
> 
...
I know that I've occasionally removed

	apic_printk(APIC_VERBOSE, "mapped IOAPIC
		to %08lx (%08lx)\n",

already fixed in v2, just do not post updated version here.

	-- Cyrill
