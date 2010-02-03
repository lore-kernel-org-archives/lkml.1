Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab0BCW1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:27:05 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32984 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab0BCW07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:26:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R/YrQRNMPMPOyfv5T5D4Eypl4M2QFlivTP6WYqG5rZ5wDZ8NPqscnN3VGXbBJtmqyk
         4rPt6w/Q6+7+Qf7AokrRHUIWtfGoFlOsUQAlpWy+XDzGs1ZQS6Ra5MG09ze4RxI7XtxO
         7jUzvw6dWeeasyUXqGaRRZS9onMma6UT02cA0=
Date: Wed, 3 Feb 2010 23:26:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the percpu tree with the tip tree
Message-ID: <20100203222616.GF5068@nowhere>
References: <20100203163822.2742bcc5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203163822.2742bcc5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 04:38:22PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the percpu tree got a conflict in
> include/linux/ftrace_event.h, include/trace/ftrace.h,
> kernel/trace/trace_kprobe.c, kernel/trace/trace_syscalls.c and
> kernel/trace/trace_event_profile.c between commit
> 430ad5a600a83956749307b13257c464c3826b55 ("perf: Factorize trace events
> raw sample buffer operations") from the tip tree and commit
> eeb721be6bc03fe37755e69ab5c3ba2fe9897fd9 ("percpu: add __percpu sparse
> annotations to trace") from the percpu tree.
> 
> I attempted to fix them up (see below) but someone should check the
> result carefully.  (The apparently unchanged files below used the tip
> tree versions.)
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



I'm not very used to review patches on patches :)

But yeah that looks good to me.

Thanks!

