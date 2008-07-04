Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYGDMjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYGDMjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYGDMjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:39:24 -0400
Received: from khc.piap.pl ([195.187.100.11]:52037 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbYGDMjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:39:23 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add missing skb->dev assignment in Frame Relay RX code
References: <m3wsk8aupw.fsf@maximus.localdomain> <486E1404.8090704@garzik.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 04 Jul 2008 14:39:22 +0200
In-Reply-To: <486E1404.8090704@garzik.org> (Jeff Garzik's message of "Fri\, 04 Jul 2008 08\:13\:56 -0400")
Message-ID: <m3bq1dzuv9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

>> Commit 4c13eb6657fe9ef7b4dc8f1a405c902e9e5234e0 ([ETH]: Make
>> eth_type_trans set skb->dev like the other *_type_trans) removed
>> skb->dev assignment from hdlc_fr.c:fr_rx(). Unfortunately it was also
>> needed for cases other than eth_type_trans().
>>
>> Adding it back.

> applied

Thanks.
-- 
Krzysztof Halasa
