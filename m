Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYDIPTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYDIPTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbYDIPT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:19:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:64506 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbYDIPTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tRwS1icDoD1wBTgfSUYYk9MvVYFOWm78WKbkAz5QBXCrOkluTlgntFVD4UdfOelsJ1h2kmUa9Zlzot0H9dTbFt7Do/NzrYb5tYt86VT0tU/6lOHMRD1SX2lRZAkls+mh+VQtrdLOYA50GuZ2DeJtGllELMh5OaUyeeOLi5Tw1IA=
Date: Wed, 9 Apr 2008 19:18:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jacek Luczak <difrost.kernel@gmail.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 9
Message-ID: <20080409151838.GC7648@cvg>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <d711229d0804090400p1c92a158j381b86e207a6f38a@mail.gmail.com> <20080409210936.ec8ea986.sfr@canb.auug.org.au> <20080409212719.7d834c13.sfr@canb.auug.org.au> <20080409113109.GA25186@elte.hu> <20080409145058.GA7648@cvg> <20080409150333.GA24451@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409150333.GA24451@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Apr 09, 2008 at 05:03:33PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > | > It seems that commit 883a9fc4e5d9b0701f15d4e5a23608f942104721 
| > | > ("x86: cleanup - rename VM_MASK to X86_VM_MASK") from the x86 tree 
| > | > seems to have missed some places.
| > | 
| > | i think what happened is that some changes came in from other trees 
| > | that reintroduced the old symbols?
| > 
| > actually, that is the only explanation I could find. The last time I 
| > sent you patches to fixup *all* VM_MASK (wich were grep'ed on *latest 
| > branch over *all* sources inside x86). So this all were settled down 
| > by a few of my patches and /for shame on me/ yours fixups. So these 
| > fixups were missed on merging.
| 
| no, the problem turned out to be that i kept those fixes too spread out, 
| and part of them went into the x86/for-akpm portion of the tree, part of 
| it went into x86/testing. Since all x86 developers work against 
| x86/testing this was never a problem - only now did it become one when i 
| shuffled patches and branch boundaries around. Such problems will go 
| away once linux-next starts using x86/testing as well. In any case i 
| moved your fixes together and fixed up the patch ordering as well.
| 
| 	Ingo
| 

ok, i see, thanks

		- Cyrill -
