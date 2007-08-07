Return-Path: <linux-kernel-owner+w=401wt.eu-S934583AbXHGWAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbXHGWAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966598AbXHGVgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:36:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43185 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966596AbXHGVgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:36:35 -0400
Message-ID: <46B8E5DE.2070107@garzik.org>
Date: Tue, 07 Aug 2007 17:36:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: brking@linux.vnet.ibm.com, santil@us.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/ibmveth.c: memset fix
References: <200708062217.04361.m.kozlowski@tuxland.pl> <46B78672.9090808@linux.vnet.ibm.com> <46B78814.50508@pobox.com> <200708062344.03443.m.kozlowski@tuxland.pl>
In-Reply-To: <200708062344.03443.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
>>>> 	Looks like memset() is zeroing wrong nr of bytes.
>>> Good catch, however, I think we can just remove this memset altogether
>>> since the memory gets allocated via kzalloc.
>> Correct, that memset() is superfluous.
> 
> Ok. Then this should do it.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/net/ibmveth.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

applied


