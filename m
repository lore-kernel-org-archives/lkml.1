Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbYHNSq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbYHNSq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbYHNSqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:46:10 -0400
Received: from khc.piap.pl ([195.187.100.11]:41090 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538AbYHNSqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:46:08 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RESEND][PATCH 2.6.27-rc3] ixp4xx_eth: fix dma_mapping_error() compile errors
References: <200808131908.m7DJ8EAp013777@harpo.it.uu.se>
	<48A3ECBE.9050909@garzik.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 14 Aug 2008 20:46:07 +0200
In-Reply-To: <48A3ECBE.9050909@garzik.org> (Jeff Garzik's message of "Thu\, 14 Aug 2008 04\:28\:46 -0400")
Message-ID: <m3zlnfl9jk.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

>> dma_mapping_error() changed in 2.6.27-rc1 to also take a device parameter,
>> but nobody bothered updating ixp4xx_eth.c. Fixed by passing the appropriate
>> device value in the dma_mapping_error() calls.
>>
>> Tested on an ixp425 box.
>>
>> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
>> Acked-by: Krzysztof Halasa <khc@pm.waw.pl>

Thanks a lot.
-- 
Krzysztof Halasa
