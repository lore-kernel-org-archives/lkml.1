Return-Path: <linux-kernel-owner+w=401wt.eu-S2992879AbXDDMU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992879AbXDDMU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 08:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992883AbXDDMU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 08:20:58 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3307 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992879AbXDDMU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 08:20:57 -0400
Date: Wed, 4 Apr 2007 14:20:53 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       flar@allandria.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404122053.GA10599@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	David Miller <davem@davemloft.net>, dwmw2@infradead.org,
	flar@allandria.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
	linux-kernel@vger.kernel.org
References: <20070404022828.5c9b97f3@the-village.bc.nu> <Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz> <20070404024400.56d016e1@the-village.bc.nu> <20070403.185026.26966290.davem@davemloft.net> <20070404121434.73d01e7e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404121434.73d01e7e@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 12:14:34PM +0100, Alan Cox wrote:
> > If you want hierarchy, create it:
> > 
> > /sys/blah/serial/controllerX/portY
> > 
> > and keeping them all under the ttyS? major keeps the simple
> > cases working sanely too.
> 
> Currently yes you could do that, but that would break all the back
> compatibility.

libata's hd->s* does that too, with probably a much larger impact.
Could udev be useful for once and make back compatibility symlinks?
Unifying serial the same way disks, cdroms, network, etc got unified
has some charm.

  OG.

