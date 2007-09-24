Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbXIXPlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbXIXPlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758634AbXIXPlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:41:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49095 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899AbXIXPlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:41:16 -0400
Date: Mon, 24 Sep 2007 16:41:14 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Wilder <dwilder@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (resend)
Message-ID: <20070924154114.GA25368@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Wilder <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <1190435014.27362.16.camel@lc4eb748232119.ibm.com> <20070922093508.GC27827@infradead.org> <46F7D9FA.3090108@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F7D9FA.3090108@us.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 08:38:34AM -0700, David Wilder wrote:
> >NACK, don't put code into Documentation/.  Put it into kernel as it's
> >actually useful kernel code.  
> 
> Are you suggesting moving the example code into kernel? Or complaining 
> about example code in /Documentation?

Both.  example code should be integrated with the build system so it
gets built.

> And add clone,exec and exit while you're at it.
> 
> Hu?  A syscall tracer sounds like a nice idea but that is not what I am 
> trying to accomplish.  I will let Systemtap handle that.

Systemtap doesn't help anyone as it's not in the tree.  I haven't even
asked you to provide a full system call tracing modulem but provide at
least one that's useful for a certain use-case (looking at processes)
instead of almost useless code.
