Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZJ1E0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZJ1E0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 00:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbZJ1E0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 00:26:16 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:61901 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZJ1E0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 00:26:15 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQEALZk50qrR7Hu/2dsb2JhbACcQKR8mFmEPwQ
X-IronPort-AV: E=Sophos;i="4.44,637,1249257600"; 
   d="scan'208";a="47191840"
From: Roland Dreier <rdreier@cisco.com>
To: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86: Don't print number of MCE banks for every CPU
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com>
	<4AE75DB9.3040702@sgi.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 27 Oct 2009 21:26:17 -0700
In-Reply-To: <4AE75DB9.3040702@sgi.com> (Mike Travis's message of "Tue, 27 Oct
	2009 13:53:13 -0700")
Message-ID: <adaeioota8m.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Oct 2009 04:26:19.0126 (UTC) FILETIME=[CBE16160:01CA5786]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > [    4.882085] CPU 1 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21

Yes, we should probably kill that debug output as well, that was on my
list of things to do.

 - R.
