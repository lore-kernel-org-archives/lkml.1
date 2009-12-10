Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZLJTg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZLJTg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZLJTg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:36:26 -0500
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:3605 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZLJTg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:36:26 -0500
Authentication-Results: rtp-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACPdIEurRN+J/2dsb2JhbADBBZcWhCsE
X-IronPort-AV: E=Sophos;i="4.47,376,1257120000"; 
   d="scan'208";a="73491082"
From: Roland Dreier <rdreier@cisco.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression
References: <20091210091040.GG8742@kernel.dk>
	<20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu>
	<67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org>
	<20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org>
	<4B2140F8.3020201@kernel.org> <20091210184506.GP8742@kernel.dk>
	<20091210190742.GS8742@kernel.dk> <4B2149B4.9060900@kernel.org>
	<adaaaxqmxvs.fsf@roland-alpha.cisco.com> <4B214D00.90908@kernel.org>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 10 Dec 2009 11:36:29 -0800
In-Reply-To: <4B214D00.90908@kernel.org> (Yinghai Lu's message of "Thu, 10 Dec
	2009 11:33:20 -0800")
Message-ID: <ada1vj2mxj6.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Dec 2009 19:36:29.0628 (UTC) FILETIME=[1209EFC0:01CA79D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > that BIOS is using first 64k for mptable. and after booting those
 > mptable is overwritten by trampoline.

So fix that BIOS people should do is to move the mptable above 64K and
leave low 64K empty?

 - R.

