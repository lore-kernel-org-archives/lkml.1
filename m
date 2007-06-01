Return-Path: <linux-kernel-owner+w=401wt.eu-S1763407AbXFASVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763407AbXFASVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762086AbXFASVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:21:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761090AbXFASVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:21:08 -0400
Date: Fri, 1 Jun 2007 14:20:56 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
Message-ID: <20070601182056.GA11716@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
	Gregor Jasny <gjasny@googlemail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com> <465BF244.5080200@gmail.com> <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org> <465F6F48.8080804@gmail.com> <alpine.LFD.0.98.0705311830360.26602@woody.linux-foundation.org> <465F8230.2040105@gmail.com> <46604E62.1000105@pobox.com> <alpine.LFD.0.98.0706010955390.3957@woody.linux-foundation.org> <466058F8.4050107@pobox.com> <alpine.LFD.0.98.0706011047000.3957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706011047000.3957@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 10:59:51AM -0700, Linus Torvalds wrote:

 > > I'm mainly interested in hearing feedback from Fedora 7 damage, before making
 > > a major decision about the probing code.  If this is a single dain bramaged
 > > device, we should avoid punishing the majority.  But if this is a trend, it
 > > warrants careful reconsideration.
 > 
 > I thought the default in Fedora was to use the PATA driver first? If so, 
 > you're going to miss a lot of cases that "just work", because they use the 
 > old driver.

There are no old drivers in F7 and beyond.

# CONFIG_IDE is not set

	Dave

-- 
http://www.codemonkey.org.uk
