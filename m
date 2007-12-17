Return-Path: <linux-kernel-owner+w=401wt.eu-S937407AbXLQUS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937407AbXLQUS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935578AbXLQURQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:17:16 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:4736 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937410AbXLQURP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:17:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NcTf85fNlUyZE9K6iplhnH5d6x76KLNS2Ya1RWWfeiHMXQS+vsKpjAewThU7098gRQy7Fpndk+QYPaPL17UpF4BjnoVeLQgSPmsPvznY60si4MrlJq+32tThJChBdYQMhuZYSKCmT2UTAnNUZikN3/Nx9vLBS0lC4omY5f40v4Y=
Subject: Re: Final kprobes rollup patches
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
In-Reply-To: <20071217160659.GC30958@elte.hu>
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu>
	 <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>
	 <4766841B.1040500@redhat.com> <20071217143050.GA13290@elte.hu>
	 <476695D9.8090904@redhat.com>  <20071217160659.GC30958@elte.hu>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 12:17:19 -0800
Message-Id: <1197922639.23402.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 17:06 +0100, Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > > cool! Please Cc: lkml and Harvey as well so that there's less 
> > > overlap in unification work - Harvey spent quite some time unifying 
> > > and cleaning up the kprobes code during the past week.
> > 
> > Should I rewrite it based on current git tree?
> > My patch includes 3 part of patches.
> > - 2 Bugfix patches (which is not merged yet.)
> > - 2 booster patches (ditto)
> > - 2 unification patches (most of this patches are already done by Harvey's patch)
> 
> would it be easier/more robust to first did the unification patches and 
> then get the bugfixes and new features in? That would give us your 
> bugfixes and new features on both 32-bit and 64-bit at the same time.
> 
> feel free to do whichever approach you prefer - but it would be nice to 
> preserve the unification and cleanup work done by Harvey.
> 
> btw., is any of your bugfixes 2.6.24 material?
> 

Well, I'll admit to being a little disappointed if my work doesn't make
it in, but there are bugfixes here.  I think my cleanup breakout is
better in the more-finegrained changes sense.  If you decide to keep
mine I'll rebase Masami's patches 1-4 on top of that and send it by
him for resubmittal.  But I'll leave it to Ingo to decide how
to procede.

Harvey

