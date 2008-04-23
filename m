Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbYDWKmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbYDWKmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYDWKmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:42:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:49533 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbYDWKmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:42:12 -0400
Subject: Re: [Linux-fbdev-devel] [PATCH 1/3] radeonfb: Fix 64 bits
	resources on 32 bits archs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: michel@tungstengraphics.com, linux-fbdev-devel@lists.sourceforge.net,
       hollisb@us.ibm.com, adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, dzu@denx.de
In-Reply-To: <20080423.025721.50367920.davem@davemloft.net>
References: <480E0A54.9010203@linux.vnet.ibm.com>
	 <1208902903.9640.138.camel@pasglop>
	 <1208943127.5632.324.camel@thor.sulgenrain.local>
	 <20080423.025721.50367920.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 20:34:21 +1000
Message-Id: <1208946861.9060.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-23 at 02:57 -0700, David Miller wrote:
> > It's up to the driver, and again, the current radeon driver doesn't
> use
> > radeonfb at all anymore...
> 
> The only portable thing is for X to use the PCI sysfs mmap() stuff,
> which current Xorg servers using libpciaccess do.
> 
> I know because I'm typing this from a sparc64 using a Radeon
> with current Xorg :-)

True :-) But I'd still like to fix the fb API for the sake of things
like directfb etc...

Ben.


