Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZAGRJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZAGRJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZAGRJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:09:32 -0500
Received: from outbound-mail-118.bluehost.com ([69.89.22.18]:58726 "HELO
	outbound-mail-118.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752025AbZAGRJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:09:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=GEhFExa0qH+MEGcKAocf1xFN37ZkB2awBP1+oUxOmpYIBThLVsR5YisPiWfJdA6uXe0drxdhAhc84xyuIZ+oO54bIynFwPxEw7AWmK/gPNLRE2rHyWnCi+BP7BPDwnPD;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 03/11] cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
Date: Wed, 7 Jan 2009 08:59:02 -0800
User-Agent: KMail/1.9.10
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <200901051159.09278.jbarnes@virtuousgeek.org> <20090107151958.GB5771@elte.hu>
In-Reply-To: <20090107151958.GB5771@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901070859.03442.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 7, 2009 7:19 am Ingo Molnar wrote:
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Monday, January 5, 2009 11:31 am Mike Travis wrote:
> > > Jesse Barnes wrote:
> > > > On Sunday, January 4, 2009 5:18 am Mike Travis wrote:
> > > >> Impact: cleanup, reduce stack usage, use new cpumask API.
> > > >>
> > > >> Replace the local cpumask_t variable with a pointer to the
> > > >> const cpumask that needs to be printed.
> > > >>
> > > >> Signed-off-by: Mike Travis <travis@sgi.com>
> > > >> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > > >
> > > > Can you resend these two against my linux-next branch?
> > > >
> > > > Thanks,
> > >
> > > Sure thing.  Would this be the latest .../sfr/linux-next.git master
> > > tree or would I need to select some other branch?
> >
> > That would probably work, but my actual tree is at
> > git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git; the
> > linux- next branch is the one that I'll be sending to Linus soon.
>
> hm, i already have it queued up in tip/cpus4096:
>
> 588235b: cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
>
> as you said that it would be fine to do it there. I guess it's not a
> problem to have it duplicate - the code changes one narrow area of code.

I don't have it queued in my tree; it depends on other changes in Linus' tree 
I haven't rebased to yet (will do today when I pull in Rafael's PCI 
suspend/resume fixes), but I'll let this stuff come through your tree alone.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
