Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYCYOkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYCYOkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYCYOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:39:52 -0400
Received: from khc.piap.pl ([195.187.100.11]:38628 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbYCYOjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:39:51 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <m3prtzsszg.fsf@maximus.localdomain>
	<m3tzj92xq6.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 25 Mar 2008 15:39:49 +0100
In-Reply-To: <m3tzj92xq6.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Fri\, 14 Mar 2008 15\:20\:49 +0100")
Message-ID: <m33aqedg0a.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote:

> New synchronous PPP implementation for generic HDLC.

So are we leaving the generic-HDLC+PPP in broken state for 2.6.25,
aren't we?

If we do, perhaps a "|| BROKEN" in drivers/net/wan/Kconfig would make
sense? Any attempt to use it will cause kernel panic immediately (PPP
with generic HDLC only; drivers using syncppp.c directly are not
affected). I can make that trivial Kconfig patch of course.
-- 
Krzysztof Halasa
