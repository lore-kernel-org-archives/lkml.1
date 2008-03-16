Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYCPWPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYCPWPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYCPWPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:15:25 -0400
Received: from khc.piap.pl ([195.187.100.11]:41026 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbYCPWPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:15:24 -0400
To: David Newall <davidn@davidnewall.com>
Cc: Daniel Phillips <phillips@phunq.net>, Willy Tarreau <w@1wt.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net>
	<200803131214.40321.phillips@phunq.net>
	<20080315205950.GA13012@1wt.eu>
	<200803151417.13899.phillips@phunq.net>
	<47DCB347.2060706@davidnewall.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 16 Mar 2008 23:15:22 +0100
In-Reply-To: <47DCB347.2060706@davidnewall.com> (David Newall's message of "Sun\, 16 Mar 2008 16\:12\:31 +1030")
Message-ID: <m3k5k28ged.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall <davidn@davidnewall.com> writes:

> Do you mean it should be replicated with a second ramback?  That would
> be pretty pointless, since all failure modes would affect both.  It's
> not like one ramback will survive a crash when the other doesn't.

It could, in a bit different location maybe, but it isn't a substitute
for ordered writes.
-- 
Krzysztof Halasa
