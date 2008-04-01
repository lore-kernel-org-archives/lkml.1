Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbYDAEIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbYDAEIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 00:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYDAEII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 00:08:08 -0400
Received: from phunq.net ([64.81.85.152]:49392 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750927AbYDAEIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 00:08:07 -0400
From: Daniel Phillips <phillips@phunq.net>
To: david@lang.hm
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 31 Mar 2008 21:07:48 -0700
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803310440.33019.phillips@phunq.net> <alpine.DEB.1.00.0803311727500.31200@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.00.0803311727500.31200@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803312107.48892.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008 17:28, david@lang.hm wrote:
> On Mon, 31 Mar 2008, Daniel Phillips wrote:
> 
> > On Tuesday 18 March 2008 09:36, david@lang.hm wrote:
> >> P.S. 8xPCI-e slots are only able to do 2GB/s of data transfer, in an
> >> earlier post Daniel claimed that you needed 3GB/s of disk to mirror to the
> >> disk, so the scenerio listed above looses 1/3 of it's performance compared
> >> to what was being claimed earlier.
> >
> > Each Violin 1010 has two 8xPCI-e interfaces.
> 
> but if you use them for redundancy by hooking them to two machines you can 
> only use one of them on your active system.

That is why you use two Violin 1010 boxes, each connected to two
servers.  The resulting mirror will have roughly 1 GByte/sec write
bandwidth and 3 GByte/sec read bandwidth.  Fast enough for you?  No?

Well then...

Continue this idea to achieve whatever bandwidth you want to the ramdisk,
subject to finding server motherboards that can take lots of PCI-e 8x
cards, which are admittedly rare, but see "have your checkbook ready".

Regards,

Daniel
