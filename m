Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZBCUzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZBCUzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZBCUzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:55:36 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:63358 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbZBCUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:55:35 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1919jj47B/ORJJexH2cxmU6
Date: Tue, 3 Feb 2009 12:55:21 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       Trilok Soni <soni.trilok@gmail.com>, Arve Hj?nnev?g <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       ext Juha Yrj?l? <juha.yrjola@solidboot.com>, viktor.rosendahl@nokia.com
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090203205518.GI7215@atomide.com>
References: <20090114035237.GB16442@kroah.com> <20090114104307.GA20451@elf.ucw.cz> <20090114104834.18387fca@lxorguk.ukuu.org.uk> <d6200be20901141426r1d48ea33gc9a380451e4aaf93@mail.gmail.com> <20090114231739.GB24111@kroah.com> <d6200be20901141532y6f236104kd521041d640c152e@mail.gmail.com> <20090115001224.GC11328@kroah.com> <5d5443650901150532r20a4c25q834afadde2f98a3@mail.gmail.com> <20090115234404.GA20142@kroah.com> <20090116090210.GB7039@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116090210.GB7039@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mundt <lethal@linux-sh.org> [090116 01:05]:
> On Thu, Jan 15, 2009 at 03:44:04PM -0800, Greg KH wrote:
> > On Thu, Jan 15, 2009 at 07:02:48PM +0530, Trilok Soni wrote:
> > > And there is one more lowmem driver developed by Nokia for Nokia 8xx
> > > tablets it seems. CCed Tony Lindgren,  Juha and Viktor.
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=blob;f=security/lowmem.c;h=ae78a530af39703e335ad769f1e6f097f63ec6dd;hb=HEAD
> > 
> > As we can't stack LSMs, using the lsm interface for a simple memory
> > driver seems pretty wasteful :)
> > 
> The heuristics and tunables are more what ended up being useful with this
> module, which could trivially be abstracted out. The focus of the lowmem
> module was mostly giving userspace an opportunity to change its behaviour,
> and to try to save critical state. I don't know how well this would map
> to the Android use cases, though.

FYI, I've dropped the lowmem.c module from the linux-omap tree
considering the rest of this thread. The commit is
c00b5565aaaefadfe68d7c32d05617c81bb9edff for reference.

Regards,

Tony
