Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbZLJWra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbZLJWra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762042AbZLJWr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:47:29 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:26877 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762028AbZLJWr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:47:28 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKoJIUurR7Hu/2dsb2JhbADANJcShCsE
X-IronPort-AV: E=Sophos;i="4.47,377,1257120000"; 
   d="scan'208";a="447853288"
From: Roland Dreier <rdreier@cisco.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Bisected regression
References: <20091210091040.GG8742@kernel.dk>
	<20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu>
	<67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org>
	<20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org>
	<4B2140F8.3020201@kernel.org> <20091210184506.GP8742@kernel.dk>
	<20091210190742.GS8742@kernel.dk> <4B2149B4.9060900@kernel.org>
	<20091210192659.GV8742@kernel.dk> <4B21630A.6000308@kernel.org>
	<4B21789F.4030707@zytor.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 10 Dec 2009 14:47:34 -0800
In-Reply-To: <4B21789F.4030707@zytor.com> (H. Peter Anvin's message of "Thu,
	10 Dec 2009 14:39:27 -0800")
Message-ID: <adaaaxqla49.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Dec 2009 22:47:34.0947 (UTC) FILETIME=[C3E6C730:01CA79EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Is this an EFI BIOS?  Otherwise, the first 64K would be clobbered anyway
 > by the boot loader, so it is invalid anyway...  If it is EFI, it is
 > theoretically possible.

Yes, EFI BIOS on an pre-release NHM EX box.

 - R.
