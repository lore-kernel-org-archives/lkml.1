Return-Path: <linux-kernel-owner+w=401wt.eu-S1767317AbXDTXFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767317AbXDTXFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 19:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767321AbXDTXFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 19:05:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40881
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1767317AbXDTXFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 19:05:47 -0400
Date: Fri, 20 Apr 2007 16:05:50 -0700 (PDT)
Message-Id: <20070420.160550.92268431.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       christopher.leech@intel.com, jgarzik@pobox.com
Subject: Re: [PATCH] NET: Add packet sock option to return orig_dev to
 userspace when bonded
From: David Miller <davem@davemloft.net>
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC329026E9753@orsmsx414.amr.corp.intel.com>
References: <D5C1322C3E673F459512FB59E0DDC329026E9753@orsmsx414.amr.corp.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Date: Thu, 8 Mar 2007 18:17:39 -0800

> Peter P. Waskiewicz Jr. <peter.p.waskiewicz.jr@intel.com>
> 	NET: Add packet sock option to return orig_dev to userspace when
> bonded

I'm going to apply this patch (by hand, your email client corrupted
the patch massively, adding newlines and whatnot all over the patch).

But I'm going to rename the option to be just PACKET_ORIGDEV
because although bonding is the only user of this orig_dev
decapsulation method, that might not always be true and it'd
be a shame to give a special cased name when it is not deserved
here.

But please do fix your email client for future patch submissions.

Thanks.
