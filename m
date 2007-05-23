Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbXEWXEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbXEWXEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbXEWXEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:04:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44902
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757564AbXEWXEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:04:12 -0400
Date: Wed, 23 May 2007 16:04:15 -0700 (PDT)
Message-Id: <20070523.160415.26274543.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: jbarnes@virtuousgeek.org, hancockr@shaw.ca, galibert@pobox.com,
       linux-kernel@vger.kernel.org, ak@suse.de, cebbert@redhat.com,
       lenb@kernel.org
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI
 motherboard resources
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.98.0705231514410.3890@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705231444200.3890@woody.linux-foundation.org>
	<200705231506.36229.jbarnes@virtuousgeek.org>
	<alpine.LFD.0.98.0705231514410.3890@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2007 15:16:23 -0700 (PDT)

> That crap should be seen for the crap it is! Dammit, how hard can it
> be to just admit that mmconfig isn't that great?

I knew mmconfig was broken conceptually the first time I started
seeing write posting "bug fixes" for it that would do a read back from
PCI config space via mmconfig to post the write, which of course has
potential side-effects on the device and is absolutely illegal if the
write just performed put the device into a PM state or whatever.

Truth is stranger than fiction at times.

MMCONFIG is very much an ill-conceived idea.

