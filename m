Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbZBOTmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbZBOTmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZBOTmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:42:40 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:37190 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZBOTmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:42:39 -0500
X-IronPort-AV: E=Sophos;i="4.38,212,1233532800"; 
   d="scan'208";a="142651915"
From: Roland Dreier <rdreier@cisco.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] staging: &&/|| typo
References: <49986CCF.4010005@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 15 Feb 2009 11:36:54 -0800
In-Reply-To: <49986CCF.4010005@gmail.com> (Roel Kluin's message of "Sun, 15
	Feb 2009 20:28:15 +0100")
Message-ID: <adamycn7aqx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Feb 2009 19:42:38.0267 (UTC) FILETIME=[8EAA48B0:01C98FA5]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > -	if(fifo_size != 0x400 || fifo_size != 0x2000)
 > +	if(fifo_size != 0x400 && fifo_size != 0x2000)

What does the presence of this bug say about the probability that this
code has ever been used for anything real?

 - R.
