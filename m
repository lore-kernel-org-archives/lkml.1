Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbXJIXUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbXJIXUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXJIXUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:20:46 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:43525 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbXJIXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:20:45 -0400
X-IronPort-AV: E=Sophos;i="4.21,250,1188802800"; 
   d="scan'208";a="533200027"
To: Greg KH <greg@kroah.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <htejun@gmail.com>,
       ebiederm@xmission.com, stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver model
X-Message-Flag: Warning: May contain useful information
References: <11902755392688-git-send-email-htejun@gmail.com>
	<20070925221736.GA3566@kroah.com> <46FB956B.8000205@gmail.com>
	<20071005061812.GA16914@kroah.com> <4705EF30.8010002@gmail.com>
	<20071009112901.6d4fa19d@gondolin> <20071009222638.GD21228@kroah.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 09 Oct 2007 16:20:39 -0700
In-Reply-To: <20071009222638.GD21228@kroah.com> (Greg KH's message of "Tue, 9 Oct 2007 15:26:38 -0700")
Message-ID: <adar6k3g9iw.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Oct 2007 23:20:39.0545 (UTC) FILETIME=[013CA690:01C80ACB]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > - relaying implementation details to userspace so that they cannot be
 > > easily changed. We would need to allow kobjects not showing up in sysfs
 > > and making symlinks a sysfs facility not relying on kobjects to help
 > > there.
 > 
 > Huh?  Why would you want a kobject to not show up in sysfs?

I think the text you replied to explained it perfectly: becase you
don't want internal implementation details to be exposed the userspace
and become an unchangeable part of the kernel/userspace interface.
