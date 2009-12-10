Return-Path: <linux-kernel-owner+w=401wt.eu-S1761604AbZLJTix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604AbZLJTix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZLJTit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:38:49 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:26853 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZLJTis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:38:48 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2009 14:38:48 EST
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFPaIEurRN+K/2dsb2JhbADBAJcWhCsE
X-IronPort-AV: E=Sophos;i="4.47,376,1257120000"; 
   d="scan'208";a="60943260"
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
X-Message-Flag: Warning: May contain useful information
Date: Thu, 10 Dec 2009 11:28:55 -0800
In-Reply-To: <4B2149B4.9060900@kernel.org> (Yinghai Lu's message of "Thu, 10
	Dec 2009 11:19:16 -0800")
Message-ID: <adaaaxqmxvs.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Dec 2009 19:28:57.0708 (UTC) FILETIME=[04AC6AC0:01CA79CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > that is funny. we may need to use find early for our TRAMPOLINE...?

 > otherwise your mptable is corrupted....

Wouldn't surprise me if mptable is messed up... most likely BIOS people
take more care to get ACPI right.

I'm not an expert on this stuff, but do we need the mptable if ACPI info
is there?

 - R.
