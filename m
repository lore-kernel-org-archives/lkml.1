Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab0AOVaT (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267Ab0AOVaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:30:18 -0500
Received: from www84.your-server.de ([213.133.104.84]:56405 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab0AOVaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:30:17 -0500
Subject: Re: [PATCH] enhanced reimplemented of the kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>
In-Reply-To: <20100115192029.GC10591@ovro.caltech.edu>
References: <1263546418.9732.11.camel@wall-e>
	 <20100115192029.GC10591@ovro.caltech.edu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Jan 2010 22:30:01 +0100
Message-ID: <1263591001.7531.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm glad to see this example, it really illustrates how to use the new
> DMA functionality of the kfifo API.
> 
> Is there any reason why a very large scatterlist could not be used? I
> have a driver that uses a large scatterlist (~4000 entries, allocated as
> a struct sg_table). I implemented my own copy_from_user() functionality
> into this scatterlist, but I'd love to use the kfifo DMA API instead.
> After filling the scatterlist, I use the usual DMA API's to transfer it
> to my device.
> 

No, but the API will only return max. two entries.

Stefani


