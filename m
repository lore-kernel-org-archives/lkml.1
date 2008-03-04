Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYCDGeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYCDGeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYCDGeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:34:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:40397 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYCDGeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:34:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=v6EIBYiyhzNniW3rfYyEB/UcYkDgwQpQFkQQcJppZ5rWPwGouaFpSBZtFeZXoW+2e
	EizwoCiLEgSIkkKYb2Pmw==
Message-ID: <6599ad830803032234v3bce2769l26379ea304fe885@mail.gmail.com>
Date: Mon, 3 Mar 2008 22:34:02 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <20080304002651.95089ff1.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080227222103.673194000@chello.nl>
	 <20080303113621.1dfdda87.pj@sgi.com> <1204567052.6241.4.camel@lappy>
	 <20080303121033.c8c9651c.pj@sgi.com>
	 <6599ad830803031041r6c635141n6520a915f2e1d08@mail.gmail.com>
	 <20080303125253.5d2d580c.pj@sgi.com>
	 <6599ad830803032126m39935eaeu1df67d6263e8e123@mail.gmail.com>
	 <20080304001507.3ddc8f26.pj@sgi.com>
	 <6599ad830803032221j740c9657yec237ebbadbeaeaa@mail.gmail.com>
	 <20080304002651.95089ff1.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 10:26 PM, Paul Jackson <pj@sgi.com> wrote:
> Paul M wrote:
>  > Except that this isn't currently possible if you're also trying to do
>  > memory hardwalling on those cpusets, since then sibling cpusets can't
>  > share memory nodes.
>
>  Yes, there would be interactions, on both the CPU and Memory side with
>  some second order mechanisms (hardwalls and sched domains.)
>
>  Still, I ask, where's the beef -- the real users?
>

I'm one such user who's been forced to add the mem_hardwall flag to
get around the fact that exclusive and hardwall are controlled by the
same flag. I keep meaning to send it in as a patch but haven't yet got
round to it.

Also, if you're using fake numa for memory isolation (which we're
experimenting with) then the correlation between cpu placement and
memory placement is much much weaker, or non-existent.

Paul
