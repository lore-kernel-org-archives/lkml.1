Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565Ab0AFHaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0AFHaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672Ab0AFHae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:30:34 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:13795 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab0AFHad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:30:33 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGXKQ0urR7Hu/2dsb2JhbAC/HJQ7hDAE
X-IronPort-AV: E=Sophos;i="4.49,227,1262563200"; 
   d="scan'208";a="462198327"
From: Roland Dreier <rdreier@cisco.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] fs: O_* bit numbers uniqueness check
References: <20100106065526.GB11368@localhost>
	<adahbqzvhgn.fsf@roland-alpha.cisco.com>
	<20100106071817.GA24428@localhost>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 05 Jan 2010 23:30:31 -0800
In-Reply-To: <20100106071817.GA24428@localhost> (Wu Fengguang's message of
	"Wed, 6 Jan 2010 15:18:17 +0800")
Message-ID: <adad41nvgfc.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jan 2010 07:30:32.0028 (UTC) FILETIME=[20D6E1C0:01CA8EA2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Yeah, I chose the boot time check because of hweight32()..

One could do something like

#define HWEIGHT32(x) (!!((x) & (1u <<  0)) +
		      !!((x) & (1u <<  1)) +
//...
		      !!((x) & (1u << 31)));

that would probably work with BUILD_BUG_ON().

But as I said maybe it's too ugly.

 - R.
