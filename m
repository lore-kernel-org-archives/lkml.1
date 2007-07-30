Return-Path: <linux-kernel-owner+w=401wt.eu-S937488AbXG3Si0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937488AbXG3Si0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760522AbXG3SiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:38:18 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:37303 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763667AbXG3SiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:38:17 -0400
Date: Mon, 30 Jul 2007 20:38:06 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: bug in slab.c
Message-ID: <20070730183806.GL1678@pengutronix.de>
References: <20070729073739.GD1678@pengutronix.de> <20070730001604.d58dca0a.akpm@linux-foundation.org> <20070730180301.GG1678@pengutronix.de> <Pine.LNX.4.64.0707301103580.743@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707301103580.743@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 11:05:09AM -0700, Christoph Lameter wrote:
> Looks like the slab header was corrupted. If this can be reproduced then 
> you need to enable slub debugging to find the kernel function that 
> corrupts memory.

Yup, I'll try that if it happens again.

> Otherwise it could be bad memory?

Hmm, the box is relatively new, but one never knows. Ah, and it was
after I've resumed the machine from suspend-to-disk, but not right after
the start but some minutes later.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

