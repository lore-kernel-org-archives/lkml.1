Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYH0TH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYH0TH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 15:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYH0THM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 15:07:12 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:40417 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYH0THL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 15:07:11 -0400
Date: Wed, 27 Aug 2008 15:06:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is SKAS still required for UML
Message-ID: <20080827190655.GB12522@c2.user-mode-linux.org>
References: <alpine.LNX.1.10.0808271251170.1378@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0808271251170.1378@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 12:57:53PM -0400, Jan Engelhardt wrote:
> the UML page at http://user-mode-linux.sourceforge.net/old/skas.html 
> mentions that "The UML kernel is present in the address space of each of 
> its processes, and, by default, is writeable".

That stuff, as you can see by the "old" in the URL, is old.

Since skas0 became the default, that statement is no longer true.
> 
> I tried to put this to a test, and actually failed to modify the 
> UML kernel/memory image from within it. I had a simple kernel module 
> with 'int val = 2;' and upon loading this, done printk("Val is at %p\n", 
> &val); to get to know the address. A userspace program inside the UML 
> then tried to dereference that address and read the value, but that 
> ended in a segfault. /proc/xxx/maps also does not show the UML kernel 
> being mapped in any process inside the UML. Note that I was running in 
> SKAS0 mode, both host and guest are all 64-bit. Is the NX bit of the 
> 64-bit platform securing things off, or has SKAS3 become sort of 
> obsolete?

SKAS3 is still a significant performance boost.

      	       		     Jeff

-- 
Work email - jdike at linux dot intel dot com
