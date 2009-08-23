Return-Path: <linux-kernel-owner+w=401wt.eu-S934042AbZHWUC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042AbZHWUC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 16:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933983AbZHWUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 16:02:28 -0400
Received: from khc.piap.pl ([195.187.100.11]:59592 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933948AbZHWUC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 16:02:28 -0400
To: Aviv Greenberg <avivgnet@gmail.com>
Cc: Walt Holman <walt@holmansrus.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Strange network timeouts w/ 2.6.30.5
References: <985009134.71250769263099.JavaMail.root@mail.holmansrus.com>
	<m3skfmk39q.fsf@intrepid.localdomain>
	<20090823191808.GA29972@linux-gec2.site>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 23 Aug 2009 22:02:27 +0200
In-Reply-To: <20090823191808.GA29972@linux-gec2.site> (Aviv Greenberg's message of "Sun\, 23 Aug 2009 22\:18\:08 +0300")
Message-ID: <m3ljlati24.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aviv Greenberg <avivgnet@gmail.com> writes:

> Why do you use PCI_DMA_BIDIRECTIONAL? From what i get, the device writes and the
> cpu reads - so the direction should be PCI_DMA_FROMDEVICE. Maybe just maybe the 
> bi-directionality bites you in the swiotlb case.

Yes, it's just been confirmed that FROMDEVICE at this point happens to
work.
-- 
Krzysztof Halasa
