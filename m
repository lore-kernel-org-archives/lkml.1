Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbXHaEht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbXHaEht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbXHaEhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:37:23 -0400
Received: from syd-iport-1.cisco.com ([64.104.193.196]:5148 "EHLO
	syd-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbXHaEhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:37:21 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2007 00:37:20 EDT
To: Steve Wise <swise@opengridcomputing.com>
Cc: general@lists.openfabrics.org, ewg@lists.openfabrics.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       sean.hefty@intel.com
Subject: Re: [PATCH RFC] iw_cxgb3: Support "iwarp-only" interfaces to avoid 4-tuple conflicts with the host stack.
X-Message-Flag: Warning: May contain useful information
References: <1187905185.5547.13.camel@stevo-desktop>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 30 Aug 2007 21:27:04 -0700
In-Reply-To: <1187905185.5547.13.camel@stevo-desktop> (Steve Wise's message of "Thu, 23 Aug 2007 16:39:45 -0500")
Message-ID: <adaveawwcpz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Aug 2007 04:27:05.0166 (UTC) FILETIME=[2F65C6E0:01C7EB87]
Authentication-Results: syd-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/syddkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The sysadmin creates "for iwarp use only" alias interfaces of the form
 > "devname:iw*" where devname is the native interface name (eg eth0) for the
 > iwarp netdev device.  The alias label can be anything starting with "iw".
 > The "iw" immediately after the ':' is the key used by the iwarp driver.

What's wrong with my suggestion of having the iwarp driver create an
"iwX" interface to go with the normal "ethX" interface?  It seems
simpler to me, and there's a somewhat similar precedent with how
mac80211 devices create both wlan0 and wmaster0 interfaces.

 - R.
