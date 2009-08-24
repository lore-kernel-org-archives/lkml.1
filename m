Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZHXJox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZHXJox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZHXJov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:44:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51468 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZHXJou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:44:50 -0400
Date: Mon, 24 Aug 2009 11:43:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Joseph Cihula <joseph.cihula@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, hpa@zytor.com,
       andi@firstfloor.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v4][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090824094353.GE25591@elf.ucw.cz>
References: <4A299051.40405@intel.com> <alpine.LRH.2.00.0906121509001.14633@tundra.namei.org> <20090619150514.GE1389@ucw.cz> <20090619183414.GG19771@sequoia.sous-sol.org> <alpine.LRH.2.00.0906221135550.18633@tundra.namei.org> <20090626213045.GA22359@elf.ucw.cz> <alpine.LRH.2.00.0906290828200.29509@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0906290828200.29509@tundra.namei.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-29 08:46:07, James Morris wrote:
> On Fri, 26 Jun 2009, Pavel Machek wrote:
> 
> > 
> > > Also, hardware security measures such as TXT are important in providing 
> > > stronger mechanisms to ensure that kernel security mechanisms are 
> > > functioning correctly.
> > 
> > I don't get it. How does TXT help kernel security mechanisms?
> 
> Kernel security mechanisms can be subverted and bypassed in the case of an 
> exploitable kernel vulnerability, or from exploitable buggy hardware (e.g. 
> which can access the entire host's memory via DMA).  Attacks on kernel 
> security mechanisms have been describe in detail, see: 
> http://www.phrack.com/issues.html?issue=66&id=15#article
> 
> This is close to impossible to solve from within the kernel alone. 
> Hardware support is required to allow protection of the IO space (e.g. via 
> IOMMU/VT-d), and to allow verification of the kernel itself (via
> TXT).

So... you can exploit kernel security holes. How does intel TXT help?

AFAICT it does not.  From what I see, intel TXT only prevents user
from physically tampering with his own machine. Preventing user from
tampering with his own machine is immoral to me, and from what I've
seen it will be ineffective as soon as user suspends the machine, uses
some liquid nitrogen, does whatever he needs with the RAM modules, and
then places them back.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
