Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbXGWWaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbXGWWaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbXGWW3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:29:53 -0400
Received: from web50109.mail.re2.yahoo.com ([206.190.38.37]:32032 "HELO
	web50109.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753854AbXGWW3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:29:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GjHLlFCmbz4EP7dtoEnfDXYStrtdqUkl/ILx7ismT6XpqagJIyCucDccfC4ID1fbzYGj/cC1PGXBbZmXywZk4MQjnJxyPn8RvwczLCkKAvmkph6t17OEUBxsu8/xqQf6Iz1sHjZ0fNaxUHhni06CB/Epm1/TOAKwpKC21qNHFvs=  ;
Message-ID: <20070723222951.33125.qmail@web50109.mail.re2.yahoo.com>
X-YMail-OSG: 5O5cN.0VM1lFUobzx7Bo5y1at5upsfDiu1TlWHXhVhyDsmKWiAcfti_lE5jtqF5GIymYrl53X0CxkVK2uXlODzP5oqFNZLc.AFI.ifr.FuoRe0Xdpa5yfhj4DTxs3awsjeF2CqwPZ7xs00sL9GaCin2uSA--
Date: Mon, 23 Jul 2007 15:29:50 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: drivers/edac: add mips and ppc visibility
To: Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Douglas Thompson <dougthompson@xmission.com>
In-Reply-To: <20070720194737.GA30184@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Dave Jones <davej@redhat.com> wrote:

> On Thu, Jul 19, 2007 at 05:59:16PM +0000, Linux Kernel wrote:
>  > Gitweb:    
>
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b113a3f7e85d7f97c8383a88a5bc7c2ea8daeb2f
>  > Commit:     b113a3f7e85d7f97c8383a88a5bc7c2ea8daeb2f
>  > Parent:     052dfb45ccb5ea354a426b52556bcfee75b9d2f5
>  > Author:     Douglas Thompson <dougthompson@xmission.com>
>  > AuthorDate: Thu Jul 19 01:50:15 2007 -0700
>  > Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
>  > CommitDate: Thu Jul 19 10:04:55 2007 -0700
>  > 
>  >     drivers/edac: add mips and ppc visibility
>  >     
>  >     1) Remove an old CVS ID string
>  >     
>  >     2) change EDAC from a tristate option to a simple bool option
>  >     
>  >     3) In addition to the X86 arch, PPC and MIPS also have drivers in the
>  >     submission queue.  This patch turns on the EDAC flag for those archs.  Each
>  >     driver will have its respective 'depends on ARCH' set.
>  >     
>  >     Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
>  >     Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>  >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> What was the reasoning behind 2) ?
> Now everyone's distro kernel has bits of EDAC in it even if they
> don't use it.  (Admittedly only a small amount, but these things
> tend to creep in bit by bit).
> 
> 	Dave

It might be my failed understanding, but the requested patch for this, was to move the
ON/OFF of EDAC into the 'drivers' submenu directly (instead of down in the EDAC submenu), 
to allow for faster disabling/enabling of EDAC in menuconfig.

But all the modules are still tri-state configured.

If I am missing something here, please give me some needed instruction. From what I understand
your comment, the code is can still be configured in modules.

thanks

doug t


> 
> -- 
> http://www.codemonkey.org.uk
> 

