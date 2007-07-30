Return-Path: <linux-kernel-owner+w=401wt.eu-S968213AbXG3TJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968213AbXG3TJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967945AbXG3TIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:08:50 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:40882 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967786AbXG3TIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:08:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALvTrUarR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.19,199,1183359600"; 
   d="scan'208"; a="191251064:sNHT886878558"
To: "Mikael Starvik" <mikael.starvik@axis.com>
Cc: "'Adrian Bunk'" <bunk@stusta.de>, "dev-etrax" <dev-etrax@axis.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: cris port lacks a merge?
X-Message-Flag: Warning: May contain useful information
References: <BFECAF9E178F144FAEF2BF4CE739C668030B5C6F@exmail1.se.axis.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 30 Jul 2007 12:08:43 -0700
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C668030B5C6F@exmail1.se.axis.com> (Mikael Starvik's message of "Mon, 30 Jul 2007 09:44:19 +0200")
Message-ID: <aday7gxso90.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jul 2007 19:08:44.0011 (UTC) FILETIME=[0C58F3B0:01C7D2DD]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The problem is that every time I try the following happens:
 > 
 > 1. I download the bleeding edge latest stuff that you can get
 > 2. I prepare and submit patches
 > 3. I get replies with comments on my patches
 > 4. I fix the patches.
 > 5. I get told that the patches are against a too old version
 > 6. Repeat from 1.

One way to reduce your backlog might be to choose a small subset of
the most urgent out of all your pending patches -- say, the minimum
required to get cris working if it doesn't build/work in the latest
kernel, or the most urgent bug fixes if it does still work -- and then
update just that subset.  By reducing the number of patches, you can
reduce the amount of time in step 4 and reduce the chance of entering
step 5.

Then, once that batch is merged, move on to the next most urgent set
of patches, etc.

Also, creating a git tree might make the job of rebasing patches
easier, and also reduces the friction in getting Linus to merge your
patches.

 - R.
