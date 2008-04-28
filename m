Return-Path: <linux-kernel-owner+w=401wt.eu-S936580AbYD1TSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936580AbYD1TSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933866AbYD1TSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:18:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49557 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934212AbYD1TSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:18:36 -0400
Date: Mon, 28 Apr 2008 20:18:34 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Gabriel C <crazy@frugalware.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>
Subject: Re: intelfb and G33 / Q33 / Q35 chipsets support ?
In-Reply-To: <4815EEB4.2060509@frugalware.org>
Message-ID: <alpine.DEB.0.82.0804282016440.5277@skynet.skynet.ie>
References: <4815EEB4.2060509@frugalware.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Gabriel C wrote:

> Hello ,
> 
> are there any plans to add G33 / Q33 / Q35 chipsets support for the intelfb driver ?
> Is this driver still maintained ?
> 
> ( I'm not really sure who maintains this driver so I've add peoples to CC I saw worked on it ,
> I've also added Wang Zhenyu to CC while he added this support for AGP )
> 

Intel fb is unmaintained (well I've done trivial fixes in the past), and 
I'd rather not add new chipset support to it.

We are working (RH and Intel) on a new kernel modesetting layer which will 
allow fbs integrated with proper memory management and support all intel 
hw, 

The main problem with intelfb is it trips up the userspace X drivers a lot 
and generally break things..

Dave.
