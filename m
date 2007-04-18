Return-Path: <linux-kernel-owner+w=401wt.eu-S2992581AbXDROTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992581AbXDROTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992584AbXDROTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:19:33 -0400
Received: from mx2.netapp.com ([216.240.18.37]:21395 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992581AbXDROTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:19:32 -0400
X-IronPort-AV: i="4.14,423,1170662400"; 
   d="scan'208"; a="52283620:sNHT17094049"
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Florin Iucha <florin@iucha.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070418141722.GI24044@iucha.net>
References: <1176868485.6796.42.camel@heimdal.trondhjem.org>
	 <20070418040730.GC24044@iucha.net>
	 <20070417211350.ebba1493.akpm@linux-foundation.org>
	 <20070418043040.GD24044@iucha.net>
	 <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
	 <20070417223738.8f49a39f.akpm@linux-foundation.org>
	 <20070418123842.GF24044@iucha.net>
	 <1176902131.6796.62.camel@heimdal.trondhjem.org>
	 <20070418134225.GG24044@iucha.net>
	 <1176905506.6796.84.camel@heimdal.trondhjem.org>
	 <20070418141722.GI24044@iucha.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 18 Apr 2007 10:19:31 -0400
Message-Id: <1176905971.6796.87.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 18 Apr 2007 14:19:37.0547 (UTC) FILETIME=[988059B0:01C781C4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 09:17 -0500, Florin Iucha wrote:
> On Wed, Apr 18, 2007 at 10:11:46AM -0400, Trond Myklebust wrote:
> > On Wed, 2007-04-18 at 08:42 -0500, Florin Iucha wrote:
> > > Could the port in CLOSE_WAIT state be the culprit?  (FWIW
> > > the server has been up for 38 days and subjected to
> > > this nfs test quite a bit without showing any stress).
> > 
> > The port in CLOSE_WAIT shows that a socket was closed down recently, but
> > once the connection is re-established, the client should start sending
> > data.
> > Do you have a copy of wireshark or ethereal on hand? If so, could you
> > take a look at whether or not any NFS traffic is going between the
> > client and server once the hang happens?
> > Note that the timeout value is 60 seconds, so if you see no immediate
> > traffic, then let the ethereal/wireshark session keep running for a
> > couple more minutes.
> 
> Should I run wireshark/ethereal on the client or on the server?

On the client, please, for the moment.

Cheers
  Trond
