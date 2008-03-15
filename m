Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYCOV0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYCOV0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYCOV0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:26:05 -0400
Received: from phunq.net ([64.81.85.152]:57019 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752072AbYCOV0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:26:04 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sat, 15 Mar 2008 13:25:48 -0800
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <20080315205950.GA13012@1wt.eu> <20080315205617.58aa8965@the-village.bc.nu>
In-Reply-To: <20080315205617.58aa8965@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151425.49592.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 13:56, Alan Cox wrote:
> > RAID controllers do not have half a terabyte of RAM. Also, you are always
> > invited to choose between speed (write back) and reliability (write through).
> 
> The write back ones are also battery backed properly, and will switched
> to write through (flushing out the cache) on the first sniff of a low
> battery signal.

In other words, exactly how ramback works.

> The decent ones (the kind used in serious business) also let you swap the
> battery backed RAM module to another card in the event of a failure of a
> card so you can complete recovery.

Right, just like the Violin 1010, whose PCI-e cable can be hotplugged
into a different server.  Or plugged into two servers at the same time,
because each 1010 has two PCI-e interfaces, so this can be done without
manual intervention.

See, we really are talking about the same thing.  Except that ramback
does it bigger and faster.

Daniel
