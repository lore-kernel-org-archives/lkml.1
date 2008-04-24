Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbYDXNj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYDXNj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYDXNju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:39:50 -0400
Received: from khc.piap.pl ([195.187.100.11]:39612 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYDXNjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:39:49 -0400
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, paulkf@microgate.com, jchapman@katalix.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <m3iqy8f57m.fsf@maximus.localdomain>
	<20080423.180849.240014014.davem@davemloft.net>
	<m3r6cv75xq.fsf@maximus.localdomain>
	<20080424.063006.153647297.davem@davemloft.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 24 Apr 2008 15:39:47 +0200
In-Reply-To: <20080424.063006.153647297.davem@davemloft.net> (David Miller's message of "Thu\, 24 Apr 2008 06\:30\:06 -0700 \(PDT\)")
Message-ID: <m3mynj74nw.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> My current plan is to add an "official" mid-layer pointer for
> these purposes.  So that the bug can have a simple fix while
> we think about how better to handle this longer term.

That would be great first step.

Though we will have to abandon syncppp use anyway, at least for
generic HDLC (I don't care much about the old ISA drivers).
-- 
Krzysztof Halasa
