Return-Path: <linux-kernel-owner+w=401wt.eu-S1032360AbXEHVXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032360AbXEHVXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967080AbXEHVXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:23:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40298 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966321AbXEHVXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:23:42 -0400
Message-ID: <4640EB19.6030005@oracle.com>
Date: Tue, 08 May 2007 14:26:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com>	<20070430235642.e576e917.akpm@linux-foundation.org>	<20070508121404.17bd97a6.randy.dunlap@oracle.com>	<alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com> <m3k5vj2iha.fsf@maximus.localdomain> <4640E62D.8060704@goop.org> <4640E8C4.4000603@garzik.org>
In-Reply-To: <4640E8C4.4000603@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jeremy Fitzhardinge wrote:
>> No, David means that "asm volatile (...)" is meaningful and OK to use.

I thought it was OK in readl(), writel(), etc... (and in asm),
but that's it.  (and jiffies)

> In a driver?  Highly unlikey it is OK.  In a filesystem?  Even more 
> unlikely it is OK to use.
> 
> The set of circumstances where 'volatile' is acceptable is very limited.
> 
> You will see it used properly in the definitions of writel(), for 
> example.  But most drivers using 'volatile' are likely bugs.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
