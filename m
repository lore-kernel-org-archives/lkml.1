Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbZAKGw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbZAKGw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 01:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZAKGwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 01:52:17 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:47012 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZAKGwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 01:52:17 -0500
X-IronPort-AV: E=Sophos;i="4.37,247,1231113600"; 
   d="scan'208";a="227569425"
From: Roland Dreier <rdreier@cisco.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Convert '/' to '!' in dev_set_name()
References: <adaljtjog90.fsf@cisco.com> <adad4evoeu9.fsf@cisco.com>
	<ac3eb2510901092230i5f1a37c6s8e7ef20cfaf67dc6@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 10 Jan 2009 22:52:15 -0800
In-Reply-To: <ac3eb2510901092230i5f1a37c6s8e7ef20cfaf67dc6@mail.gmail.com>
	(Kay Sievers's message of "Sat, 10 Jan 2009 07:30:24 +0100")
Message-ID: <adapriumj1c.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Jan 2009 06:52:15.0792 (UTC) FILETIME=[23771300:01C973B9]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Great! Thanks a lot for fixing this,

I assume you will make sure this gets upstream (since the problem causes
some boxes with root on cciss to panic on boot, and possibly breaks
other stuff)?
