Return-Path: <linux-kernel-owner+w=401wt.eu-S964778AbXDEDeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbXDEDeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964780AbXDEDeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:34:20 -0400
Received: from ozlabs.org ([203.10.76.45]:60086 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778AbXDEDeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:34:19 -0400
Subject: Re: [PATCH] Lguest32 print hex on bad reads and writes
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, virtualization@lists.osdl.org,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1175742848.9371.33.camel@localhost.localdomain>
References: <1175714071.9371.31.camel@localhost.localdomain>
	 <1175742090.12230.630.camel@localhost.localdomain>
	 <72C854B9-1A7F-44C5-9D62-B6B63F3A6DE7@mac.com>
	 <1175742848.9371.33.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 13:34:17 +1000
Message-Id: <1175744057.12230.632.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 23:14 -0400, Steven Rostedt wrote:
> On Wed, 2007-04-04 at 23:06 -0400, Kyle Moffett wrote:
> 
> > > (Erk, I wonder what I was thinking when I wrote that?) Can I ask  
> > > for %#x (or 0x%x)?  I'm easily confused.
> > 
> > How about "%p" for pointers?
> 
> But that would require casting the numbers to pointers.

And the kernel's printk doesn't put 0x on pointers anyway, last I
checked 8(

Rusty.


