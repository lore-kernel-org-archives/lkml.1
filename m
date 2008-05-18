Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbYERGlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbYERGlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 02:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYERGkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 02:40:53 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:22565 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYERGkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 02:40:52 -0400
Date: Sun, 18 May 2008 09:45:51 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] remove the OSS trident driver
Message-ID: <20080518064551.GD7421@il.ibm.com>
References: <20080513210544.GB23977@martell.zuzino.mipt.ru> <20080514054707.GB6682@il.ibm.com> <20080516002355.GM1936@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516002355.GM1936@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 03:23:55AM +0300, Adrian Bunk wrote:
> On Wed, May 14, 2008 at 08:47:08AM +0300, Muli Ben-Yehuda wrote:
> >...
> > Also, I no longer have working trident hardware---if someone else does
> > and can test this, please let me know. Otherwise we can should
> > probably go ahead and remove this old OSS driver.
> 
> Considering that we have a working ALSA driver for this hardware, and 
> your past objections against the removal were the sole reason why this 
> is the only PCI OSS driver we still have in the tree, I'd actually 
> prefer doing this (patch below).
> 
> Is this OK for you?

Yep. Please also add to the patch the CREDITS snippet below.

> SOUND_TRIDENT was the last PCI OSS driver, and since there's already an 
> ALSA driver for the same hardware we can remove it.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>

diff --git a/CREDITS b/CREDITS
index 8fec7b3..2259308 100644
--- a/CREDITS
+++ b/CREDITS
@@ -317,6 +317,14 @@ S: 2322 37th Ave SW
 S: Seattle, Washington 98126-2010
 S: USA
 
+N: Muli Ben-Yehuda
+E: mulix@mulix.org
+E: muli@il.ibm.com
+W: http://www.mulix.org
+D: trident OSS sound driver, x86-64 dma-ops and Calgary IOMMU,
+D: KVM and Xen bits and other misc. hackery.
+S: Haifa, Israel
+
 N: Johannes Berg
 E: johannes@sipsolutions.net
 W: http://johannes.sipsolutions.net/
