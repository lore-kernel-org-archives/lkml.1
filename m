Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbXLFNYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbXLFNYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 08:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXLFNY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 08:24:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:56653 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbXLFNY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 08:24:27 -0500
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <C608AAD4-29F7-4D5D-AA85-3B28CCCAADE5@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <20071206081628.GA15868@parisc-linux.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b resources
Date: Thu, 6 Dec 2007 07:24:12 -0600
References: <20071205064116.D849BDE10A@ozlabs.org> <1196911347.7033.15.camel@pasglop> <20071206063940.GA16474@kroah.com> <1196927934.7033.39.camel@pasglop> <20071206081628.GA15868@parisc-linux.org>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 6, 2007, at 2:16 AM, Matthew Wilcox wrote:

> On Thu, Dec 06, 2007 at 06:58:54PM +1100, Benjamin Herrenschmidt  
> wrote:
>> I was just hoping somebody had a better idea, like a way to add a new
>> format specifier to printk without losing gcc type checking :-)
>
> It's been discussed before.  Some of the solutions discussed:
>
> - Add something like PRI_RES which can be concatenated into a printk.
>   Ugly.
> - Patch gcc to allow user-definable types.  I think OpenBSD has a  
> patch
>   for this.  Then we have to get that patch propagated to all the
>   people who compile the kernel.  Unappetising.
> - Disable gcc's printk checking, teach sparse to typecheck printk.
>   Most people don't run sparse yet.

How does gcc deal with glibc extension to allow people to add their  
own specifiers?

http://www.gnu.org/software/libc/manual/html_node/Customizing-Printf.html

- k

