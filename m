Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZKWVZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZKWVZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbZKWVZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:25:33 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:36222 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbZKWVZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=nIZux1YRaxR9/walKZ7A9JCFXWIvQFk5ao45ziiL57LRaq4N79Q1f70xg/il/iwR5F
         XqzY0Wz2edAp+DtUVM9pXBBQLb6e4YOjqzFg5jimP4wzdRxDAk2Ri0xtuWjRIX1M5p63
         6Ps5YxnasDvn0T3ebV7UxVTFoUHx8i7MMfjU8=
Date: Mon, 23 Nov 2009 19:25:25 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/4] perf tools: Add support for breakpoint events in
	perf tools
Message-ID: <20091123212525.GE15547@ghostprotocols.net>
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com> <1258987355-8751-4-git-send-email-fweisbec@gmail.com> <20091123173601.GA7273@in.ibm.com> <20091123202525.GA4979@nowhere> <20091123210939.GD15547@ghostprotocols.net> <20091123211945.GC4979@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123211945.GC4979@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 23, 2009 at 10:19:47PM +0100, Frederic Weisbecker escreveu:
> On Mon, Nov 23, 2009 at 07:09:39PM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Nov 23, 2009 at 09:25:28PM +0100, Frederic Weisbecker escreveu:
> > > I think we should find this symbol length from userspace. I'm not sure
> > > how yet, probably using Dwarf. Arnaldo, do you have an idea about that?
> > 
> > DWARF has the type for each variable or struct member, getting its size
> > is straightforward.
> 
> Ok.
> 
> > Using just /proc/kallsyms all we can do is find the size of a variable
> > by looking at its address and the address of the next one.
> 
> Hmm, but I worry a bit about alignment which would return us
> the wrong size.
> 
> May be can we first try to get the address from /proc/kallsyms,
> and if we have dwarf, get the size from it, otherwise try some
> magic with /proc/kallsysms...

Yeah, I'll get the variables-from-kallsyms bit just after I get a new
mechanism for expressing configuration for the perf symbol resolving
machinery.

Should have this done ASAP.

- Arnaldo
