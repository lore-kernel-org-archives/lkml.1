Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZIISBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZIISBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZIISBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:01:14 -0400
Received: from relay2.sgi.com ([192.48.179.30]:34268 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752373AbZIISBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:01:14 -0400
Date: Wed, 9 Sep 2009 13:01:10 -0500
From: Jack Steiner <steiner@sgi.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: SGU UV Add volatile to macros that access chipset registers
Message-ID: <20090909180110.GA10311@sgi.com>
References: <20090909154246.GA26716@sgi.com> <1252512600.14793.125.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252512600.14793.125.camel@desktop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 09:10:00AM -0700, Daniel Walker wrote:
> On Wed, 2009-09-09 at 10:42 -0500, Jack Steiner wrote:
> > Add "volatile" to the SGI UV read/write macros that are used to access chipset
> > memory mapped registers.
> 
> There is a considerable document regarding the usage of volatile in the
> kernel (Documentation/volatile-considered-harmful.txt). Considering that
> document, can you give a more descriptive reason why your using
> "volatile" here ?
> 

I knew that "volatile" would catch someone's attention  :-)


Volatile is being added to the accessor functions that are used to
read/write memory-mapped I/O registers located within the UV chipset.
The use of volatile is hidden within the functions and is not exposed
to the users of the functions.

Note that the use is limited to the accessor functions in the header
file. No .c files are changed or need to know about volatile.


This seems to be consistent with other uses of volatile within the kernel.


--- jack
