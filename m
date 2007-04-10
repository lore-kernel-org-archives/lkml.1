Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbXDJVNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbXDJVNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXDJVNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:13:14 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:33633 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbXDJVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:13:12 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Milind Arun Choudhary <milindchoudhary@GMAIL.COM>,
       kernel-janitors@lists.osdl.org, kernelnewbies@nl.linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ]remove SPIN_LOCK_UNLOCKED
X-Message-Flag: Warning: May contain useful information
References: <20070410181654.GA10525@arun.site>
	<Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 10 Apr 2007 14:13:02 -0700
In-Reply-To: <Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr> (Jan Engelhardt's message of "Tue, 10 Apr 2007 22:50:28 +0200 (MEST)")
Message-ID: <adafy78orvl.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Apr 2007 21:13:02.0235 (UTC) FILETIME=[05F15EB0:01C77BB5]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Fact is, we cannot remove SPIN_LOCK_UNLOCKED. It's needed for
 > variables outside functions:
 > 
 > static spinlock_t foobar = SPIN_LOCK_UNLOCKED;

DEFINE_SPINLOCK() is provided to define variables that way.

 - R.
