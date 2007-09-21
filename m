Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbXIUINg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbXIUINg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXIUINU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:13:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45949 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXIUINT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:13:19 -0400
Date: Fri, 21 Sep 2007 09:08:08 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Christoph Hellwig <hch@infradead.org>,
       David Wilder <dwilder@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Test harness in the kernel for new syscalls? [Was: Trace code and documentation (updated)]
Message-ID: <20070921080808.GB29050@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Sam Ravnborg <sam@ravnborg.org>, David Wilder <dwilder@us.ibm.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com> <p736427vz00.fsf@bingen.suse.de> <46F12ED7.3060605@us.ibm.com> <20070919162018.GA16237@infradead.org> <20070919095223.83bd8226.randy.dunlap@oracle.com> <20070919165507.GA18973@infradead.org> <20070919174845.GD3115@uranus.ravnborg.org> <20070919175109.GA23889@infradead.org> <20070919180115.GE3115@uranus.ravnborg.org> <20070920215042.38fd3546.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920215042.38fd3546.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 09:50:42PM -0700, Randy Dunlap wrote:
> so kernel sample code goes in the new samples/ directory,
> and userspace sample code gets pushed to util-linux ?

I'm not sure we want to have purely sample code in util-linux, but rather
extended sample code that makes some use.  So if you're writing user space
sample code for your new feature make sure it's somewhat production quality,
has a useful interface and write a little manpage for it.  That'll also help
us to win sysdamins hearts back because BSD and solaris already have all these
neat little tools that need to be hacked from scratch in perl on Linux.

For kernel code a samples dir might make sense because say a demo of the
firmware loader (one of those things in Documentation/ right now) of
course never can be "real" code.  OTOH a fork probe as provided with the
tracing code sounds more like a real thing that should go into drivers/misc/.
