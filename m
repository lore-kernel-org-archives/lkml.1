Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYCPXI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYCPXI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYCPXIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:08:50 -0400
Received: from khc.piap.pl ([195.187.100.11]:40675 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYCPXIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:08:50 -0400
To: Daniel Phillips <phillips@phunq.net>
Cc: David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net>
	<47DCB347.2060706@davidnewall.com>
	<m3k5k28ged.fsf@maximus.localdomain>
	<200803161538.06282.phillips@phunq.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 17 Mar 2008 00:08:48 +0100
In-Reply-To: <200803161538.06282.phillips@phunq.net> (Daniel Phillips's message of "Sun\, 16 Mar 2008 14\:38\:05 -0800")
Message-ID: <m31w6a8dxb.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> writes:

>> It could, in a bit different location maybe, but it isn't a substitute
>> for ordered writes.
>
> How so?

Not sure if I understand the question correctly but obviously a pair
(mirror) of servers running "dangerous" ramback would survive a crash
of one machine and we could practically eliminate the probability of
both (all) machines crashing simultaneously. However, there are
cheaper ways to achieve similar performance and even better
reliability - including those battery-backed (RAI)Disk controllers.
-- 
Krzysztof Halasa
