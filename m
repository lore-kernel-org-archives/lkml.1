Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbZHJMcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbZHJMcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZHJMca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:32:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45867 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbZHJMc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:32:29 -0400
Date: Mon, 10 Aug 2009 14:32:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Stezenbach <js@sig21.net>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090810123228.GD6838@basil.fritz.box>
References: <20090807170942.GB9177@sig21.net> <87k51cgdt8.fsf@basil.nowhere.org> <20090810122731.GA5863@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810122731.GA5863@sig21.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The appended patch should remove the warning. Can you please test it?
> 
> It works (no more warning), but I feel I'm better off using "lapic"

Thanks for testing.

> because it enables thermal monitoring and performance counters.

When the BIOS doesn't enable it then force enabling lapic might not work.

This could cause either boot failures (obvious) or more subtle
problems like SMM doing something unexpected. Just saying that if you have 
strange problems later first try disabling this option again.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
