Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZLAUVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZLAUVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZLAUVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:21:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:60481 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbZLAUVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:21:36 -0500
Subject: Re: powerpc: syscall_dotrace() && retcode (Was: powerpc: fork &&
 stepping)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Veaceslav Falico <vfalico@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com, Jan Kratochvil <jan.kratochvil@redhat.com>
In-Reply-To: <20091201192750.4A1291DE@magilla.sf.frob.com>
References: <20091126145051.GB4382@redhat.com>
	 <20091126172524.GA14768@redhat.com>
	 <20091126182226.GF12355@darkmag.usersys.redhat.com>
	 <20091126202312.GA21945@redhat.com>
	 <19214.63688.860929.962005@cargo.ozlabs.ibm.com>
	 <20091126223703.GA28556@redhat.com>
	 <20091127174627.GB26193@darkmag.usersys.redhat.com>
	 <20091128073049.GD23108@in.ibm.com> <20091129210716.GA19205@redhat.com>
	 <1259536501.2076.39.camel@pasglop> <20091130200136.GB11764@redhat.com>
	 <20091201192750.4A1291DE@magilla.sf.frob.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 07:17:47 +1100
Message-ID: <1259698667.2076.935.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 11:27 -0800, Roland McGrath wrote:
> 
> If the powerpc maintainers want to change the behavior here, that is fine
> by me.  But there is no need for that just to satisfy general ptrace
> cleanups (or utrace).  Normal concerns require that no such change break
> the ptrace behavior that userland could have relied on in the past.
> 
> So off hand I don't see a reason to change at all.  If every arch were to
> change so that registers changed at syscall-entry were left unmolested by
> aborting the syscall, then that might be a new consistency worth having.
> But short of that, I don't really see a benefit.
> 
> All this implies that the ptrace-tests case relating to this needs to be
> tailored differently for powerpc and each other arch so it expects and
> verifies exactly the arch-specific behavior that's been seen in the past. 

Ok thanks. I'm happy to not change it then, the risk of breaking some
existing assumption is too high in my book.

Cheers,
Ben.


