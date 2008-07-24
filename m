Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYGXQC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYGXQC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYGXQCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:02:19 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:20742 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYGXQCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:02:18 -0400
Date: Thu, 24 Jul 2008 11:02:16 -0500
From: scameron@beardog.cca.cpqcorp.net
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       mike.miller@hp.com, scameron@beardog.cca.cpqcorp.net
Subject: Re: HP (Compaq) Smart Array 5xxx controller SCSI driver
Message-ID: <20080724160216.GL8833@beardog.cca.cpqcorp.net>
References: <20080722175729.GC8833@beardog.cca.cpqcorp.net> <20080724101953R.fujita.tomonori@lab.ntt.co.jp> <20080724133012.GH8833@beardog.cca.cpqcorp.net> <20080724224438B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724224438B.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.9i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In case it is of interest, here are the patches 
to the 2.6.20.4 kernel which make a SCSI Smart Array
driver that I did in April of 2007.  I called the 
driver "hpsa", for HP Smart Array.

https://sourceforge.net/project/showfiles.php?group_id=33072&package_id=285296

I made these patches on a system which was booted from
a SmartArray 6400 using the cciss driver, so the first 
patch disables cciss support in the cciss driver for the P800, 
and the resulting SCSI driver supports only the Smartarray P800,
as I was doing the SCSI driver development on a P800 I had in
the system.  That's the only reason that stuff is in 
there in the 1st patch.

Because of the way the first few patches move files around,
these probably aren't particularly useful directly as patches
(and of course, they're for an old kernel anyway), but might
be useful as an illustration of one way things might be done.

-- steve

