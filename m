Return-Path: <linux-kernel-owner+w=401wt.eu-S935194AbXHHCcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935194AbXHHCcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 22:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758490AbXHHCbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 22:31:55 -0400
Received: from perm68-235.ij.net ([209.216.68.235]:4478 "EHLO smirk.3gfp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758403AbXHHCbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 22:31:53 -0400
Message-ID: <46B92B10.7@3gfp.com>
Date: Tue, 07 Aug 2007 22:31:44 -0400
From: Harvey Chapman <hchapman-linux-kernel@3gfp.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial inter-character timeout usage with async io
References: <46B8F7FE.3090904@3gfp.com> <20070808021147.10d0e752@the-village.bc.nu> <46B92869.4000400@3gfp.com>
In-Reply-To: <46B92869.4000400@3gfp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Chapman wrote:
> just don't identify it specifically. In the ISRs, they simply check to
> see if any of bits 1, 2, or 3 are set. In the example above, on the last

Well, not entirely true, it actually checks bit 0 which indicates that
there was an interrupt, period. Bits 1, 2, and 3 indicate why the
interrupt occurred, but 8250.c and pxa.c ignore those bits.

