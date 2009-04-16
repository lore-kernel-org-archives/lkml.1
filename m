Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZDPKW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZDPKW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZDPKWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:22:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45032 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZDPKWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:22:48 -0400
Date: Thu, 16 Apr 2009 11:21:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] percpu + mutex fixes
Message-ID: <20090416102142.GA26366@ZenIV.linux.org.uk>
References: <alpine.LFD.2.00.0904100915010.4583@localhost.localdomain> <20090410165030.GQ26366@ZenIV.linux.org.uk> <20090410170507.GR26366@ZenIV.linux.org.uk> <20090410171415.GA6033@ZenIV.linux.org.uk> <20090410180532.GA4419@jurassic.park.msu.ru> <alpine.LFD.2.00.0904101118470.4583@localhost.localdomain> <49DF935E.8030607@kernel.org> <49DF97D0.9090506@kernel.org> <20090410193444.GA18039@elte.hu> <20090410194055.GA21133@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410194055.GA21133@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 09:40:55PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Now i understand the rush ...
> > 
> > Yes, moving the APIs to the generic header should properly expose 
> > the wrapped default implementations. I'll test your patch in a 
> > minute.
> 
> Alpha builds fine with your patch:
> 
>   LD      .tmp_vmlinux2
>   KSYM    .tmp_kallsyms2.S
>   AS      .tmp_kallsyms2.o
>   LD      vmlinux
>   SYSMAP  System.map
> 
> Linus,
> 
> If that patch is OK to you too, please pull the latest 
> core-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus
> 
> it includes this fix and a pending mutex fixlet.

(Belated) ACK.  As for unification of that stuff, I'll gladly leave that
as SEP...
