Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbXLQTR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbXLQTR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbXLQTRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:17:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:44953 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbXLQTRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:17:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JWTNfRmzeT5n1b8Vn988Bub4FcMA2VPVpzr1bX1rMIrBLXr3xsfdypSES4eSz4Os3EbrUdgvBUJ3GyeChvd33PdKJ0iN8UvPZwtezIUmGKILPzsxVZ3YAzRJ9TGzjS2X81zftjkcppgP/WesM9QHOMxc3ZWdm0GtrZN2CdfsORI=
Subject: Re: [-mm][PATCH 0/6] (yet another) kprobes x86 code unification
	and boosters
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071217163342.GA10495@elte.hu>
References: <47669E87.1010506@redhat.com>  <20071217163342.GA10495@elte.hu>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 11:17:22 -0800
Message-Id: <1197919042.23402.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 17:33 +0100, Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Hello all,
> > 
> > I developed a series of patches which unifies kprobes code on x86 and 
> > introduces boosters on x86-64. These patches can be applied to 
> > 2.6.24-rc4-mm1.
> > 
> > The purpose of this patchset is unifying kprobes_[32|64].[c|h] to 
> > kprobes.[c|h] for simplifying code maintenance.
> > 
> > I know these patches are conflicting with Harvey's patch. We need to 
> > solve that.
> 
> your series fixes the 64-bit crash that i was seeing, so i've picked it 
> up. Please work it out with Harvey which cleanups of him are not 
> included yet.
> 

I thought the jprobe_saved_sp looked fishy on X86_64 in my unified set
but I went bug-for-bug compatible I guess :-)  If you look at my cleaned
up set this was one of the main source of remaining ifdefs.

Harvey


