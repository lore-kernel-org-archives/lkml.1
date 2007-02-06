Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbXBFJIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbXBFJIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:08:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbXBFJIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:08:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39449 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbXBFJIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:08:04 -0500
Subject: Re: [PATCH 0/11] VMI / Paravirt bugfixes for 2.6.21
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <1170738676.29293.35.camel@localhost.localdomain>
References: <200702060352.l163q87K000713@zach-dev.vmware.com>
	 <1170736029.29293.31.camel@localhost.localdomain>
	 <45C809F9.2090905@vmware.com>
	 <1170738676.29293.35.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 06 Feb 2007 10:07:36 +0100
Message-Id: <1170752856.7324.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 16:11 +1100, Rusty Russell wrote:
> On Mon, 2007-02-05 at 20:54 -0800, Zachary Amsden wrote:
> > Rusty Russell wrote:
> > > Indeed, I'm expecting to push lguest this week, and this code will
> > > effect me, so I'd like to see this in a -mm soon...
> > 
> > Yes, I took a look at the lguest changes today and I think these won't 
> > generate conflicts, just make stuff easier for you ;)  Course you've now 
> > got a couple new paravirt-ops to support, but the native ones are fine 
> > for temporary use.
> 
> Implementing stolen time is something I'd like to do, since it'd be a
> nice self-contained example the expectations.


hmm stolen time could even be useful without virtualization; to a large
degree, if cpufreq reduces the speed of your cpu you have "stolen
cycles" that way... I wonder if this concept can be used for that as
well...


