Return-Path: <linux-kernel-owner+w=401wt.eu-S2992564AbXDLPeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992564AbXDLPeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992567AbXDLPet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:34:49 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:27647 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992564AbXDLPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:34:48 -0400
X-IronPort-AV: i="4.14,403,1170662400"; 
   d="scan'208"; a="477774656:sNHT209250128"
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
X-Message-Flag: Warning: May contain useful information
References: <1175644642.10567.31.camel@shinybook.infradead.org>
	<20070403221002.GA13210@cynthia.pants.nu>
	<1175648051.10567.61.camel@shinybook.infradead.org>
	<20070403.181645.68159458.davem@davemloft.net>
	<20070404022828.5c9b97f3@the-village.bc.nu>
	<Pine.LNX.4.64.0704032307001.7802@mtl.rackplans.net>
	<m3tzvm6fgw.fsf@ursa.amorsen.dk>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Apr 2007 08:34:40 -0700
In-Reply-To: <m3tzvm6fgw.fsf@ursa.amorsen.dk> (Benny Amorsen's message of "11 Apr 2007 18:30:39 +0200")
Message-ID: <adabqhtip2n.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Apr 2007 15:34:40.0676 (UTC) FILETIME=[1618CE40:01C77D18]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Indeed, port density is disappointingly poor in modern servers. Do you
 > know any with more than 14 ports per U? (That's an MBX 1U server with
 > 8 on-board and a 6-port expansion).

If you really need a ton of ports you could probably build a 1U server
with 2 * 2-port 10gig NICs, and use VLAN-capable switches with 10gig
and 1gig ports to fan out each 10gig link from your server to 10 1-gig
ports.  That would get you 40 ports of 1-gig from each server (plus
whatever the server has on board).

 - R.
