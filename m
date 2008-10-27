Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbYJ0X2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYJ0X2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJ0X2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:28:32 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:48786 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYJ0X2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:28:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zlf/7895+eBazpdX09nRi1Oc3ZSAOGEi61WdtwM363LfZ0cKHK//Anb//MK4c5yCBR
         JEn42UhTqtL18M2wPWQ7c7xRSjsHUVL82caqy+paZcXda19MfmwJLWBVJVRi6A4PpQkq
         P3WJjloxe5/ptJcexZm2KoPkU+I84X6P/7IRg=
Date: Tue, 28 Oct 2008 02:31:53 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       anders@anduras.de, netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv3] printk: add %pM format specifier for MAC
	addresses
Message-ID: <20081027233153.GA11367@x200.localdomain>
References: <1225124904.5440.1.camel@brick> <20081027.123805.134354592.davem@davemloft.net> <1225137542.5396.10.camel@brick> <20081027.154736.178482850.davem@davemloft.net> <1225149254.6339.4.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225149254.6339.4.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 04:14:14PM -0700, Harvey Harrison wrote:
> On Mon, 2008-10-27 at 15:47 -0700, David Miller wrote:
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > Date: Mon, 27 Oct 2008 12:59:02 -0700
> > 
> > > Add format specifiers for printing out six colon-separated bytes:
> > > 
> > > MAC addresses (%pM):
> > > xx:xx:xx:xx:xx:xx
> > > 
> > > %#pM is also supported and omits the colon separators.
> > > 
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > Applied, thanks.
> 
> Did you happen to have a preference with regard to the specifier for
> IPv6 addresses:
> 
> I was thinking of using %pI6 to replace NIP6() and NIP6_FMT and using
> %#pI6 for NIP6_SEQFMT.
> 
> On the IPv4 side, maybe use %pI4 for network endian NIPQUAD() and NIPQUAD_FMT
> and then %#pI4 for host-endian HIQUAD(), as displaying the IPv4 address without
> the periods isn't useful?

%#pI4 is horrible and %p4 and %p6 were cool.
