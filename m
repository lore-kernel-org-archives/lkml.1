Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYDAGI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYDAGI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYDAGIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:08:18 -0400
Received: from phunq.net ([64.81.85.152]:49505 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751350AbYDAGIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:08:18 -0400
From: Daniel Phillips <phillips@phunq.net>
To: david@lang.hm
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 31 Mar 2008 23:08:00 -0700
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803312107.48892.phillips@phunq.net> <alpine.DEB.1.10.0803312121141.14049@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0803312121141.14049@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803312308.00946.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008 21:23, david@lang.hm wrote:
> > Continue this idea to achieve whatever bandwidth you want to the ramdisk,
> > subject to finding server motherboards that can take lots of PCI-e 8x
> > cards, which are admittedly rare, but see "have your checkbook ready".
> 
> so is it possible to use ramback safely without buying the violin boxes? 
> from your posts it doesn't seem like it.

Of course it does not depend on Violin's exact hardware, which is just
very nice hardware for this purpose if you can afford it, and makes it
easy to see how to provide proper safeguards for critical data.

> as a sample, say you were to take a pair of the sun x4600 boxes and 
> populate them with 256G of ram each. how would you use 200G of ram on the 
> box as a database with ramback?

Similar idea.  Dual power supplies come with these boxes, so connect
each to two independent UPS units.  Place a very fast interconnect
between the boxes, Infiniband or something more exotic.  Then the
configuration is a mirror of ramback devices, just as with the Violin
1010's.  Advantages of this arrangement: save some money; local memory
bus speed instead of PCI-e.  Disadvantages: no raided, hotpluggable
memory; cannot take one of the servers down without losing the mirror
level redundancy; less total capacity than the 1010's.

Regards,

Daniel
