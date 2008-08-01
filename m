Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbYHAXS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbYHAXS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYHAXST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:18:19 -0400
Received: from colo.lackof.org ([198.49.126.79]:46259 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYHAXST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:18:19 -0400
Date: Fri, 1 Aug 2008 17:18:07 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/20] parisc: use the new byteorder headers
Message-ID: <20080801231807.GA26550@colo.lackof.org>
References: <1216339783.6029.125.camel@brick> <20080801160647.GA22049@colo.lackof.org> <1217625817.5846.5.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217625817.5846.5.camel@brick>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 02:23:37PM -0700, Harvey Harrison wrote:
...
> > Should this only be defined if BITS_PER_LONG is <=32  ?
> 
> The new byteorder headers only uses this if no __arch_swab64 is defined.
> 
> Further down in the parisc version, an __arch_swab64 is defined in the
> BITS_PER_LONG >=32 case, making this moot.

Ok.

...
> Other than the endianness, any other concerns?

Have you had a chance to test this?
Or can you point me at another big endian arch that has similar 
use of header files that has been successfully tested?

I can arrange for access to parisc HW if you have time/interest
in testing this yourself.

thanks,
grant

> 
> Harvey
