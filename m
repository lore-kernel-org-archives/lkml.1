Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYHAQuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYHAQuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYHAQuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:50:01 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:19281 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbYHAQuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:50:00 -0400
Date: Fri, 1 Aug 2008 18:49:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080801164941.GC2299@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <1217579712.10483.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217579712.10483.7.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 10:35:12AM +0200, Martin Schwidefsky wrote:
> On Mon, 2008-07-28 at 22:05 +0200, Sam Ravnborg wrote:
> > So I have hacked up support for this in kbuild so
> > for the simpler cases a simple move of header files as
> > in:
> > 	git mv include/asm-$ARCH arch/$ARCH/include/asm
> > 
> > is enough.
> 
> Just tested it on s390. We need a tiny fix for the qeth driver then it
> works just fine (qeth has two includes for include/asm-s390 instead of
> include/asm). I'll queue the qeth fix on git390. The only question is
> who will do the move? 

You will do so and ask Linus to pull it. This most go via the
arch maintainer.
And I'm glad that no other changes were needed.

	Sam
