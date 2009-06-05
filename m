Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZFEJcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZFEJcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZFEJcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:32:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46668 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZFEJcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:32:46 -0400
Date: Fri, 5 Jun 2009 05:32:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alex Samad <alex@samad.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Message-ID: <20090605093234.GA30705@infradead.org>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <PkPeJtNB3KO.A._pF.ZVbIKB@chimera> <20090530231018.GA29992@samad.com.au> <200906012221.38854.rjw@sisk.pl> <4A27DA01.8060105@windsormachine.com> <20090604143406.GA19536@infradead.org> <alpine.DEB.1.10.0906041038500.15712@router.windsormachine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906041038500.15712@router.windsormachine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 10:40:01AM -0400, Mike Dresser wrote:
> On Thu, 4 Jun 2009, Christoph Hellwig wrote:
>
>> Can you please also run with CONFIG_XFS_DEBUG enabled so that all
>> kinds of asserts might trigger?
>
> The help for that option says the "code will be HUGE and SLOW"
>
> How much of a slowdown are we likely talking about?

I haven't actually measured it, but it shouldn't be that bad.  Mostly
it's adding tons of ASSERT statements.  The Kconfig help is there to
prevent people from enabling it just because they can.

