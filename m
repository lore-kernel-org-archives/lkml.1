Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZAETuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZAETuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZAETty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:49:54 -0500
Received: from outbound-mail-21.bluehost.com ([69.89.21.16]:39477 "HELO
	outbound-mail-21.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753402AbZAETtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:49:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=cWlvgq1jIqbK5D5vMwcnPDUkaTKL2Bxxvg1Scc56wL819Zysr4Ns9Fg9iGWjLqY97m4sh4jDq1eK6w1d4QedbLoWg2RMe1WYfewfum86/qK6+uwLAgsfTniUdMMCSnvD;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 03/11] cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
Date: Mon, 5 Jan 2009 11:49:49 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <200901051127.03598.jbarnes@virtuousgeek.org> <alpine.LFD.2.00.0901051139410.3057@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901051139410.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051149.50337.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 5, 2009 11:44 am Linus Torvalds wrote:
> On Mon, 5 Jan 2009, Jesse Barnes wrote:
> > Can you resend these two against my linux-next branch?
>
> Btw, Jesse, what's the schedule for merging the pci thing.

Just pulling together some more patches today; was planning on sending a pull 
request tomorrow.

> I'm currently planning on -rc1 next weekend, which gives us time to do at
> least a shortened -rc2 before people are at LCA. And the suspend/resume
> changes are some of the more "exciting" (aka scary) parts of the whole
> merge window, so I'd rather get them merged with a few days to go, rather
> than just before -rc1.
>
> In fact, they are probably more scary than the cpumask changes, since at
> least the cpumask issues are likely to not be a big deal with any normal
> sane config (ie you really do have to enable MAXSMP to hit the stack usage
> issues). So if you end up waiting for those, I'd rather prefer to first
> merge the rest of the PCI code.

Yeah, they're no big deal, just wanted to get them (the cpumask changes) 
queued up...

> Or did the PCI late-suspend/early-resume patches go in somebody elses
> tree and I'm barking up the wrong tree entirely?

No they're coming through my tree; just need to ping Rafael again and get the 
latest set.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

