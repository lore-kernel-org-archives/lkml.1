Return-Path: <linux-kernel-owner+w=401wt.eu-S965529AbXCTRTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbXCTRTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXCTRTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:19:33 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:32775 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965529AbXCTRTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:19:32 -0400
Date: Tue, 20 Mar 2007 18:21:19 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UDP packets scheduling
Message-ID: <20070320172119.GT22880@mail.muni.cz>
References: <20070320005228.GN22880@mail.muni.cz> <p73r6rj6bv0.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <p73r6rj6bv0.fsf@bingen.suse.de>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 Mar 2007 18:19:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 06:52:51PM +0100, Andi Kleen wrote:
> > Flow control must be turned off for some other reason.
> 
> That's your fundamental problem. Fix that. 
> 
> Even if you get the rate right there can be many reasons why timing 
> gets disrupted temporarily and to recover from any of this you need
> working flow control.

How do you want to enable wire/fibre flow control, e.g., from Europe to USA?
You are not guaranteed any hardware based flow control.

And as of software flow control, you need precise timing of UDP packets to
keep desired packet rate. How to do it at speeds about 5.5Gbps, that is my
question.

-- 
Luká¹ Hejtmánek
