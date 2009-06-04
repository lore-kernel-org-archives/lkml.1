Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZFDOer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZFDOer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZFDOek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:34:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZFDOej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:34:39 -0400
Date: Thu, 4 Jun 2009 10:34:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alex Samad <alex@samad.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Message-ID: <20090604143406.GA19536@infradead.org>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <PkPeJtNB3KO.A._pF.ZVbIKB@chimera> <20090530231018.GA29992@samad.com.au> <200906012221.38854.rjw@sisk.pl> <4A27DA01.8060105@windsormachine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A27DA01.8060105@windsormachine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 10:28:17AM -0400, Mike Dresser wrote:
> I am testing 2.6.30-rc8 on the server that has issues with 2.6.29.4,  
> I'll most likely know tonight or tomorrow morning if that kernel fixes  
> it.. I noticed a lot of xfs changes in rc8 so I figured it was worth a 
> try.

Can you please also run with CONFIG_XFS_DEBUG enabled so that all
kinds of asserts might trigger?

