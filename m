Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZKFV5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZKFV5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 16:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758666AbZKFV5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 16:57:16 -0500
Received: from outbound-mail-307.bluehost.com ([67.222.53.253]:34291 "HELO
	outbound-mail-307.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758659AbZKFV5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 16:57:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=j3yIw+JA9Nel8qHrtSqWNcjOsjgv+vTpd8h06Bwre34l+J9ECLQJWT7vh2R3ipj2KqKUokP3F9x9iYxvLeTTU7KKr0N+gbXOWn92L/+VKIuvHibaJfS41xcbwh+CXDqX;
Date: Fri, 6 Nov 2009 13:57:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [resend] i915: high power consumption after suspend/resume
Message-ID: <20091106135722.5abfdd03@jbarnes-piketon>
In-Reply-To: <cb0375e10911061225y1bc29807y5abd67e748ef4164@mail.gmail.com>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	<cb0375e10910072044m470c8cbasef33de3b36bb62ee@mail.gmail.com>
	<20091029094723.7e5a3376@jbarnes-g45>
	<cb0375e10910291022l5650994dyc4a36d55f1e5bbc4@mail.gmail.com>
	<cb0375e10910291040i31a7b9aatb6da5c20778d9791@mail.gmail.com>
	<cb0375e10910292325l659034c4u36cf263cda8e90c8@mail.gmail.com>
	<20091030083742.48f5d4f3@jbarnes-g45>
	<cb0375e10910301155s5e2b2e79t562bfa798ba75e23@mail.gmail.com>
	<cb0375e10911042000h3cf215a1o44add74510c15a1c@mail.gmail.com>
	<20091105082829.2d59dcae@jbarnes-piketon>
	<cb0375e10911061225y1bc29807y5abd67e748ef4164@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009 15:25:26 -0500
Andrew Lutomirski <luto@mit.edu> wrote:
> Here's what the docs say:
> 
> 
> 2030, 2034: ring buffer head/tail
> 2074: Active head pointer register
> 20AC: Interrupt Status Register (ISR)
> 2218: Reserved
> 2358, 235C: TIMESTAMP
> 
> 1xxxx: MCHBAR aperture
> 
> 61110: PORT_HOTPLU_EN
> 61114: PORT_HOTPLU_STAT
> 61170: UDI_IF_CTL (UDI InfoFrame Control)
> 
> 61260: BLM_HIST_CTL (Image BLM Histogram Control Register)
> 
> 620B4: Reserved (for High Definition?)
> 
> 71000: PIPEB_DSL (Pipe B Display Scan Line Count)
> 71040: PIPEBFRAMEH: Pipe B Frame Count High
> 71048: Reserved
> 
> Any ideas?

Thanks, that helps.  It doesn't look like the documented ones would
have much effect (maybe hotplug enable bits?), I'll have to look
through the MCHBAR differences to see if there's anything there we
should worry about.

-- 
Jesse Barnes, Intel Open Source Technology Center
