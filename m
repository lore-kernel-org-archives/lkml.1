Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZIGLWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZIGLWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZIGLWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:22:31 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:45082 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZIGLWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KCkypFnMZXXK89vYrGlifPaXojbmLPvJ3uPaACUDFgZWL7+wm8R3szzPSSWHZuW1jX
         2MEoyLL+SPIC9VjAegptwt4vNXvDMAkxmyeULtLGqP2PkiZJusYxRjJXPkPEqMn7czXd
         7fvy9GoYW22gu4oCz+iOZSEvjAmHscp2MZ/NI=
Date: Mon, 7 Sep 2009 13:22:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Blunck <jblunck@suse.de>
Cc: Ulrich Lukas <ulrich.lukas@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <williams@redhat.com>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 00/18] tracing/ring-buffer: fixes for latency tracer
	[2.6.32]
Message-ID: <20090907112225.GC6393@nowhere>
References: <20090904235527.520961911@goodmis.org> <20090905150658.GA13387@ghostprotocols.net> <4de7f8a60909070320j692d746drb06bd635ca7f7c55@mail.gmail.com> <20090907102838.GA6393@nowhere> <20090907104155.GD28804@bolzano.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907104155.GD28804@bolzano.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 12:41:55PM +0200, Jan Blunck wrote:
> On Mon, Sep 07, Frederic Weisbecker wrote:
> > Ah, Ulrich Lukas also reported me such warnings. I would like to
> > track the reason of these messages (the hrtimer hanging detection
> > seems to warn too early).
> > 
> > Could you please send me your config, I hope I could reproduce it.
> > 
> 
> I only see that on one of my systems, a 32 core Opteron and not on my 8
> core. So it seems that size does matter ...


Ah then I have few chances to reproduce it with my boxes :-)

I'll try anyway, thanks!

