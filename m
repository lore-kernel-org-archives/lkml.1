Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbXJ2PsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbXJ2PsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbXJ2PsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:48:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40179 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbXJ2PsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:48:03 -0400
Date: Mon, 29 Oct 2007 16:48:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yoav Artzi <yoavar@checkpoint.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Linux kernel memory and split on 64-bit machines
Message-ID: <20071029154801.GA31335@one.firstfloor.org>
References: <4725C1EB.10205@checkpoint.com> <p73abq23yu4.fsf@bingen.suse.de> <4725EC21.7000603@checkpoint.com> <20071029150035.GA30851@one.firstfloor.org> <4725F6F7.6020702@checkpoint.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4725F6F7.6020702@checkpoint.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 05:06:31PM +0200, Yoav Artzi wrote:
> I don't know what befell me. I realized the foolishness of the questions 
> a second after clicking the send button.
> 
> 
> Now, I just wonder what will happen when people will need more then 
> 2^46bytes of memory. Any idea?

The CPU needs to be extended then beyond 48bit VA.

(actually it could be extended to 2^46.5 or so) 


> 
> Another two issues:
> 
> 1. I see vmalloc() doesn't cover the entire possible space. Why is that?

It needs an reserved space for its virtual mappings.

> 
> 2. How come user space gets 47bits and kernel only gets 46bits in direct 
> mapping?

Half of the kernel space is reserved for special purposes 
(vmalloc, ioremap etc.) That is not fixed and could be varied.

-Andi

