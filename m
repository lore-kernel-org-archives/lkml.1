Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZA0XOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZA0XOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZA0XOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:14:34 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:34180 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZA0XOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:14:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gm5OLN0EeL0yZD3zyZ2BaKoJMhaQe1m8s2mYfZaNA+93x8rk582GKS7OCVKInb6X23
         cxet3txgW8YVOr3Ye0Alf5OdYCarnAzuVmyX+jd/Dp466NoPWC/kXVhBO+0eMhnQT6pt
         pccW6JaPwwAAgXhqhatcwrB3GDFma1cupXhzk=
Date: Tue, 27 Jan 2009 17:13:51 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: Re: Modversions and long symbol names
Message-ID: <20090127231351.GA19513@mediacenter>
References: <20090120173636.GB24529@mediacenter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120173636.GB24529@mediacenter>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 11:36:36AM -0600, Shawn Bohrer wrote:
> Currently when modversions is enabled the kernel will not load any
> modules that depend on exported symbols with names longer than
> 64 - sizeof(unsigned long) characters.
> 
> This is because the struct modversion_info has the name member set to a
> size of MODULE_NAME_LEN.  This is not the module name this is the symbol
> name so I'm guessing this is a mistake or at least a misused constant.
> 
> Is it possible to increase this size to something more reasonable like
> 512 characters?

Hopefully everyone is back from linux.conf.au and is caught up on email
now.  Is there a reason modversions imposes this small symbol name
length?  Unfortunately I have modules that have longer exported symbol
names and this prevents them from loading on kernels that have
modversions enabled.  Of course they load just fine when modversions is
disabled.  I can't just shorten my symbol names because they are
exported and other modules are using them.

--
Shawn
