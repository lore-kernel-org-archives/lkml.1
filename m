Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbXFASqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbXFASqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762028AbXFASqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:46:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762086AbXFASqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:46:15 -0400
Date: Fri, 1 Jun 2007 14:46:05 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
Message-ID: <20070601184605.GD16529@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
	Gregor Jasny <gjasny@googlemail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org> <465F6F48.8080804@gmail.com> <alpine.LFD.0.98.0705311830360.26602@woody.linux-foundation.org> <465F8230.2040105@gmail.com> <46604E62.1000105@pobox.com> <alpine.LFD.0.98.0706010955390.3957@woody.linux-foundation.org> <466058F8.4050107@pobox.com> <alpine.LFD.0.98.0706011047000.3957@woody.linux-foundation.org> <20070601182056.GA11716@redhat.com> <alpine.LFD.0.98.0706011127500.3957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706011127500.3957@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 11:30:49AM -0700, Linus Torvalds wrote:

 > > There are no old drivers in F7 and beyond.
 > > # CONFIG_IDE is not set
 > 
 > Ahh, that's certainly going to root out the issues. Now let's hope that 
 > people install it..

Whilst it's too early to tell yet, there are a few really nasty bugs
that made it into our final kernel (based on 2.6.21.3).
For eg, a whole class of Dell laptops won't boot unless you boot
with maxcpus=1  I root-caused this to one of tglx's patches that went
into 2.6.21.2, but it's a head-scratcher as to why it's responsible.
I'm praying that this is the worst of the 'cant install' bugs we get,
and then I can just push out a 2.6.22 some time that will magically
make all these problems go away. (Because .22 is going to be flawless right?)

 > (Fedora seems to make it hard on purpose to upgrade between major 
 > revisions, but maybe that's just me not reading the docs as usual ;)

Probably :-)   I've done two successful upgrades yesterday, one with
anaconda, and one using just rpm -U of the fedora-release rpm from F7
and then 'yum update'.  (The former did go a little smoother though tbh).

	Dave

-- 
http://www.codemonkey.org.uk
