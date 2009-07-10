Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbZGJMqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbZGJMqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbZGJMkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:40:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:55299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbZGJMk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:40:29 -0400
Subject: Re: [PATCH 2:2][MTD][NAND]omap : Adding DMA mode support in nand 
 prefetch/post-write
From: David Woodhouse <dwmw2@infradead.org>
To: dedekind@infradead.org
Cc: vimal singh <vimalsingh@ti.com>, linux-mtd@lists.infradead.org,
       Tony Lindgren <tony@atomide.com>, david-b@pacbell.net,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
In-Reply-To: <1247227344.20721.363.camel@localhost.localdomain>
References: <63362.192.168.10.89.1247226916.squirrel@dbdmail.itg.ti.com>
	 <1247227344.20721.363.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 13:40:21 +0100
Message-Id: <1247229621.29541.4.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 15:02 +0300, Artem Bityutskiy wrote:
> On Fri, 2009-07-10 at 17:25 +0530, vimal singh wrote:
> > +	/* The fifo depth is 64 bytes. We have a sync at each frame and frame
> > +	 * length is 64 bytes.
> > +	 */
> > +	int buf_len = len/64;
> 
> To optimize performance it is better not to rely on gcc and use <<

If you ever see gcc screwing up division of an 'int' by a constant 64,
file a GCC bug.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

