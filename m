Return-Path: <linux-kernel-owner+w=401wt.eu-S1946293AbXBIKJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946293AbXBIKJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946289AbXBIKJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:09:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:34120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946265AbXBIKJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:09:45 -0500
From: Andi Kleen <ak@muc.de>
To: virtualization@lists.osdl.org
Subject: Re: [PATCH 1/10] lguest: Don't rely on last-linked fallthru when no paravirt handler
Date: Fri, 9 Feb 2007 10:31:20 +0100
User-Agent: KMail/1.9.5
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171012458.2718.30.camel@localhost.localdomain>
In-Reply-To: <1171012458.2718.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091031.20249.ak@muc.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 10:14, Rusty Russell wrote:

> +unhandled_paravirt:
> +	/* Nothing wanted us: try to die with dignity (impossible trap). */ 
> +	movl	$0x1F, %edx
> +	pushl	$0
> +	jmp	early_fault

Please print a real message with early_printk


-Andi
