Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZHTKSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZHTKSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZHTKSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:18:44 -0400
Received: from queue01.mail.zen.net.uk ([212.23.3.234]:57515 "EHLO
	fizeau.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZHTKR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:17:56 -0400
X-Greylist: delayed 1168 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 06:17:56 EDT
Message-ID: <4A8D1E2E.1010006@csr.com>
Date: Thu, 20 Aug 2009 10:58:06 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
References: <1250714990.13476.3.camel@wall-e>	 <1250715606.13476.15.camel@wall-e> <1250715819.3407.88.camel@Joe-Laptop.home>
In-Reply-To: <1250715819.3407.88.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.70.146.43
X-SA-Exim-Mail-From: david.vrabel@csr.com
Subject: Re: [PATCH 4/7] kfifo: rename kfifo_put... into kfifo_in... and kfifo_get...
 into kfifo_out...
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on localhost)
X-Originating-Smarthost01-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2009-08-19 at 23:00 +0200, Stefani Seibold wrote:
>> rename kfifo_put... into kfifo_in... to prevent miss use of old non in kernel-tree drivers
>> ditto for kfifo_get... -> kfifo_out...
> 
> I would have thought
> 	kfifo_put -> kfifo_out
> 	kfifo_get -> kfifo_in
> but maybe that's just me.

Use push and pull instead?  In and out (whichever way) isn't obvious enough.

David
