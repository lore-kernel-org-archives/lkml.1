Return-Path: <linux-kernel-owner+w=401wt.eu-S1761703AbXISRvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703AbXISRvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXISRvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:51:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50059 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXISRvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:51:16 -0400
Date: Wed, 19 Sep 2007 18:51:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Wilder <dwilder@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (updated)
Message-ID: <20070919175109.GA23889@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	David Wilder <dwilder@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com> <p736427vz00.fsf@bingen.suse.de> <46F12ED7.3060605@us.ibm.com> <20070919162018.GA16237@infradead.org> <20070919095223.83bd8226.randy.dunlap@oracle.com> <20070919165507.GA18973@infradead.org> <20070919174845.GD3115@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919174845.GD3115@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 07:48:45PM +0200, Sam Ravnborg wrote:
> > Well, this is kernel code - so util-linux is not the solution here
> > obviously :)
> 
> Can you sketch what you have in mind.
> We right now have said we wnated to:
> 1) include a framework for executing simple new-syscall-test-stubs
> 2) have a nice place for kernel example code
> 
> I could come up with something but I expect you already have something
> in your mind where to put stuff.
> If I have a rough idea I can start looking into the kbuild bits of it.
> Not that I will have it ready within the next two weeks but nice buffer
> when I anyway drop sleeping..

I think for samples we just want a samples/ toplevel directory with
normal Kbuild and Kconfig files.  Not any different from drivers or
filesystems, just a new hiearchary.

tests stuff was rather disliked by Linus, so I wonder wether we should
go ahead with it.  We'd need a test driver like expect to driver the
testcases.
