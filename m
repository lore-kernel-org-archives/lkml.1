Return-Path: <linux-kernel-owner+w=401wt.eu-S965698AbXBGSHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698AbXBGSHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965699AbXBGSHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:07:25 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11742 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965698AbXBGSHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:07:23 -0500
Date: Wed, 7 Feb 2007 10:03:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Levitsky Maxim <maximlevitsky@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [NET] dmfe : number of fixes and features
Message-Id: <20070207100339.2e4c4824.randy.dunlap@oracle.com>
In-Reply-To: <131364.59702.qm@web38502.mail.mud.yahoo.com>
References: <131364.59702.qm@web38502.mail.mud.yahoo.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 09:57:21 -0800 (PST) Levitsky Maxim wrote:

> Hello,
> 
> Before some time I decided to fix suspend/resume on my Davicom network card.
> During development I also fixed couple of bugs and added support for link detection and WOL
> Note : 2.6.20 already has support for link detection , but it is broken when card has external PHY
> , like mine.
> 
> So here it goes:
> 
> [PATCH] [NET] [001] dmfe : trivial/spelling fixes
> [PATCH] [NET] [002] dmfe : Fix possible oops
> [PATCH] [NET] [003] dmfe : fix link detection
> [PATCH] [NET] [004] dmfe : Add suspend/resume support
> [PATCH] [NET] [005] dmfe : Add support for wake-on-lan

Hi,
Please use a different Subject: line for each patch (like you have
listed them above).

Also, please send network driver patches to netdev@vger.kernel.org .

Oops, MAINTAINERS should list netdev@ for DMFE.
And it does list a maintainer for DMFE, so you should cc: him on
the patches.

Thanks.
---
~Randy
