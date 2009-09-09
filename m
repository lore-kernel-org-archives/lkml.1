Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZIISLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZIISLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZIISLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:11:10 -0400
Received: from fifo99.com ([67.223.236.141]:33113 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZIISLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:11:10 -0400
Subject: Re: [PATCH] x86: SGU UV Add volatile to macros that access chipset
 registers
From: Daniel Walker <dwalker@fifo99.com>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <20090909180110.GA10311@sgi.com>
References: <20090909154246.GA26716@sgi.com>
	 <1252512600.14793.125.camel@desktop>  <20090909180110.GA10311@sgi.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 11:11:25 -0700
Message-Id: <1252519885.14793.135.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 13:01 -0500, Jack Steiner wrote:
> On Wed, Sep 09, 2009 at 09:10:00AM -0700, Daniel Walker wrote:
> > On Wed, 2009-09-09 at 10:42 -0500, Jack Steiner wrote:
> > > Add "volatile" to the SGI UV read/write macros that are used to access chipset
> > > memory mapped registers.
> > 
> > There is a considerable document regarding the usage of volatile in the
> > kernel (Documentation/volatile-considered-harmful.txt). Considering that
> > document, can you give a more descriptive reason why your using
> > "volatile" here ?
> > 
> 
> I knew that "volatile" would catch someone's attention  :-)
> 
> 
> Volatile is being added to the accessor functions that are used to
> read/write memory-mapped I/O registers located within the UV chipset.
> The use of volatile is hidden within the functions and is not exposed
> to the users of the functions.
> 
> Note that the use is limited to the accessor functions in the header
> file. No .c files are changed or need to know about volatile.
> 
> 
> This seems to be consistent with other uses of volatile within the kernel.

The document that I cited specifically addresses memory accessors as not
needing the volatile keyword .. So your still not addressing exactly why
your code needs it .. Are your accessors special in some way? Is there
some defect your seeing without the volatile keyword?

Daniel

