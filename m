Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbXFTUzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbXFTUzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXFTUzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:55:05 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:53366 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbXFTUzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:55:03 -0400
Date: Wed, 20 Jun 2007 13:54:40 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] 2.6.22-rc3 perfmon2 : Debug messages added
Message-ID: <20070620205440.GD26200@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070620182126.248753000@amd.com> <20070620184113.GC5874@erda.amd.com> <alpine.DEB.0.99.0706201245490.4562@chino.kir.corp.google.com> <20070620202216.GA26200@frankl.hpl.hp.com> <alpine.DEB.0.99.0706201326310.6935@chino.kir.corp.google.com> <20070620203944.GB26200@frankl.hpl.hp.com> <alpine.DEB.0.99.0706201341140.8396@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706201341140.8396@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Wed, Jun 20, 2007 at 01:45:22PM -0700, David Rientjes wrote:
> On Wed, 20 Jun 2007, Stephane Eranian wrote:
> 
> > > What's the current status of the perfmon2 patchset that Robert's work is 
> > > based on?
> > 
> > Well, I have been hacking on it a lot especially to allow Oprofile and
> > perfmon2 to co-exist (mutual-exclusion). I am hoping to release something
> > before I fly to OLS next week. I have started integrating  Robert's patches.
> > I also have to integrate IBM's Cell support patch.
> > 
> 
> Mutual exclusion between oprofile and perfmon2 will be great; I'm 
> starting to see why you added the "implementation" field.  If you could 
> integrate Robert's patches into your own then I think it will be easier 
> for review from the community.

I have removed the "implementation" field for now. It is only useful if 
Oprofile is implemented on top of perfmon2. It is used by Oprofile
tools to detects which interface to use so that they can be used with
older kernels as well. But for now, I am shooting for Oprofile using
its own kernel code and /dev/oprofile interface. That will provide
for a smoother transition.

-- 

-Stephane
