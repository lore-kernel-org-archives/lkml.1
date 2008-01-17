Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYAQTcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYAQTcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYAQTci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:32:38 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:41737 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYAQTch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:32:37 -0500
To: "Pravin Nanaware" <p.nanaware@nihilent.com>
Cc: "John Hubbard" <john.hubbard@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Bitops source problem
X-Message-Flag: Warning: May contain useful information
References: <1145971D427D7F43B0DBDAE22221C4B5035FDDAD@nipns00a210.FPS.NIHILENT.COM>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 17 Jan 2008 11:32:30 -0800
In-Reply-To: <1145971D427D7F43B0DBDAE22221C4B5035FDDAD@nipns00a210.FPS.NIHILENT.COM> (Pravin Nanaware's message of "Thu, 17 Jan 2008 13:41:20 +0530")
Message-ID: <adahchcxn75.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jan 2008 19:32:31.0385 (UTC) FILETIME=[B3C43090:01C8593F]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Yes, indeed none of the atomic bit operations functions has
 > LOCK_PREFIX in my version of Linux kernel.

You have a broken source tree then.  Where did your kernel source come
from then?  I'm not able to find any version of asm-i386/bitops.h
where clear_bit() doesn't have LOCK_PREFIX in any of the trees I
happen to have lying around  (which includes some very old trees like 2.4.21)

 - R.
