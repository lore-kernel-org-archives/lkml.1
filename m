Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbXGDPlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbXGDPlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 11:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXGDPlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 11:41:40 -0400
Received: from gw.goop.org ([64.81.55.164]:48245 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbXGDPlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 11:41:40 -0400
Message-ID: <468BBFB3.9080303@goop.org>
Date: Wed, 04 Jul 2007 08:41:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [PATCH] x86: make SMP locks handling interact properly with	CONFIG_DEBUG_RODATA
 (2nd try)
References: <468B5B54.76E4.0078.0@novell.com>
In-Reply-To: <468B5B54.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Instead of suppressing the change of .text to become readonly, make
> the SMP locks patching code properly adjust/restore the page access
> rights.
>   

I guess we'll need to do the same thing for paravirt_ops patching?

> On x86-64 additionally remove all mappings past the kernel image, and
> remove leftovers from the removal of the more general (but abandoned)
> SMP alternatives.
>   

I'd already posted a patch to remove smp alternatives.  I thought it had 
been merged already, but I guess it's in Andi's queue.

    J
