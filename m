Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZDKBic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZDKBic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 21:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbZDKBiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 21:38:15 -0400
Received: from ozlabs.org ([203.10.76.45]:41214 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbZDKBiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 21:38:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default percpu allocator
Date: Sat, 11 Apr 2009 11:08:06 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, heiko.carstens@de.ibm.com
References: <49D3231D.2040403@kernel.org> <20090409094713.GA6538@jurassic.park.msu.ru> <49DDE1B5.4070407@kernel.org>
In-Reply-To: <49DDE1B5.4070407@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904111108.08323.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009 09:23:25 pm Tejun Heo wrote:
> It's generally a good idea to use uniquely
> distinguisible identifier for static symbols anyway to help debugging.

Sorry, I can't let this statement stand.  It's completely wrong: use the
shortest clear name, always.

> If this limitation is acceptable, I think we should also add the dup
> build failure thing to the generic definition too tho so that such
> cases can be discovered before they hit alpha and s390 later.
> 
> Any objections?

Yes.  If we decide that static per-cpu is unsupportable, let's not hide the
damn thing.  We just make it give a compile warning if we can, patch out the
current cases, and make checkpatch.pl warn on new ones.

Don't silently override "static".  Don't come up with stupid justifications.
Accept with open-eyes that it's evil, just a lesser evil.

Thanks,
Rusty.
