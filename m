Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXBXVzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXBXVzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 16:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbXBXVzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 16:55:14 -0500
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:31417 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752300AbXBXVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 16:55:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pe6b6cNuIUUOaCKlVHJlK4Xp04A/A6+fn1nJWuiGIFpWcIX3F7dy0Mc48akxIcYHE1wr5vpBAbsN2R7Gw3xNQoMNMlylXr5DGLyYd9s1TYQwJPViD9BhHXGBt7vozHz5bSLRdKoxTAOkosWzJ2/WiIBqjb/jYkS8rsiycbtwats=  ;
X-YMail-OSG: A8nfaToVM1kxAuCY_hdVd88O5C1KKT_TRovXsF004xHS6_Tzjml1XA6_00Ujcb7MyCdZ644U97kHz2DNxVt9thOJrb5DzWq6Jr3hdHOMTkStpQ_uhssVPNXychPvdzmXGCbN5i3nNu10qzEaDRspgJp2
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch/rfc 2.6.20-git] parport reports physical devices
Date: Sat, 24 Feb 2007 13:49:40 -0800
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       andrea@suse.de, tim@cyberelk.net, philb@gnu.org
References: <200702182108.08217.david-b@pacbell.net> <200702190840.30643.david-b@pacbell.net> <20070220221043.ead0b744.khali@linux-fr.org>
In-Reply-To: <20070220221043.ead0b744.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702241349.40906.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 February 2007 1:10 pm, Jean Delvare wrote:
> 
> > There are probably good reasons (== deep hardware braindamage on older
> > systems that are now hard to find) for the strange init sequencing in
> > that code, but I can't see why they should prevent splitting out
> > 
> > 	(a) device discovery via probing, PNP, or whatever; from
> > 
> > 	(b) the driver itself, getting handed a device node that's
> > 	    pre-configured with the resources reported by discovery.
> > 
> > Maybe the maintainers of the parport stack will have comments.  Though
> > the info in MAINTAINERS seems dated, if not obsolete.
> 
> Phil Blundell and Tim Waugh did not reply to me last time I sent a
> parport cleanup patch to them. I suspect they are indeed no longer
> maintaining parport in practice.

Neither of them seem to have acked patches in drivers/parport for some
time either, much less signed off on them.  And that webpage lists the
latest patches (from Tim) ... for 2.5.6-pre2!!  For the moment I've got
the appended patch in my set of parport patches.  Unless one of the
folk listed as maintainers (cc'd) squawks appropriately, I'll send this
along with the next batch of patches. 

- Dave


The writing on the wall seem to be that the parport stack is orphaned,
rather than maintained...

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Index: g26/MAINTAINERS
===================================================================
--- g26.orig/MAINTAINERS	2007-02-20 22:17:27.000000000 -0800
+++ g26/MAINTAINERS	2007-02-20 22:22:57.000000000 -0800
@@ -2553,16 +2553,8 @@ L:	i2c@lm-sensors.org
 S:	Maintained
 
 PARALLEL PORT SUPPORT
-P:	Phil Blundell
-M:	philb@gnu.org
-P:	Tim Waugh
-M:	tim@cyberelk.net
-P:	David Campbell
-P:	Andrea Arcangeli
-M:	andrea@suse.de
 L:	linux-parport@lists.infradead.org
-W:	http://people.redhat.com/twaugh/parport/
-S:	Maintained
+S:	Orphan
 
 PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
 P:	Tim Waugh
