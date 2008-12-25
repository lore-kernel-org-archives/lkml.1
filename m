Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbYLYK6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbYLYK6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 05:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYLYK6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 05:58:37 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:36045 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbYLYK6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 05:58:35 -0500
Date: Thu, 25 Dec 2008 11:58:50 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081225105850.GF4414@ics.muni.cz>
References: <20081213095815.GA7143@ics.muni.cz> <20081215011645.GA9707@localhost> <20081215094409.GA4422@ics.muni.cz> <20081216045938.GA1000@localhost> <20081216195219.GA4480@ics.muni.cz> <20081217122726.GA21356@localhost> <20081217123307.GF4480@ics.muni.cz> <20081217124421.GA22317@localhost> <20081217124904.GG4480@ics.muni.cz> <20081225105001.GC15733@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081225105001.GC15733@localhost>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 85.132.163.129
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 25 Dec 2008 11:58:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 06:50:01PM +0800, Wu Fengguang wrote:
> Did the undroppable memory keep growing?

unfotunatley not any more.
 
> If not, we could take it as a feature instead of bug: the memory
> mapped pages are being protected from being freed.  It's not a
> regression either: the feature was there before 2.6.27.
> 
> But sure we change that if it's not the desirable behavior.

so I think the issue can be closed for now. I will reopen if I discover
something.

-- 
Luká¹ Hejtmánek
