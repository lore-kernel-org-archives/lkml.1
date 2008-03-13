Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbYCMTuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbYCMTuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYCMTt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:49:58 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:59913 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752585AbYCMTt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:49:57 -0400
Message-ID: <47D9856E.9010304@davidnewall.com>
Date: Fri, 14 Mar 2008 06:20:06 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: david@lang.hm, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803130216.03230.phillips@phunq.net> <alpine.DEB.1.00.0803130914320.22040@asgard.lang.hm> <200803131232.07879.phillips@phunq.net>
In-Reply-To: <200803131232.07879.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> The period where you cannot access the data is downtime.  If your script
> just does a cp from a disk array to the ram device you cannot just read
> from the backing store in that period because you will need to fail over
> to the ramdisk at some point, and you cannot just read from the ramdisk
> because it is not populated yet.

Wouldn't a raid-1 set comprising disk + ramdisk do that with no downtime?
