Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYBQUtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYBQUtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYBQUtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:49:14 -0500
Received: from server077.de-nserver.de ([62.27.12.245]:45962 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYBQUtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:49:13 -0500
Message-ID: <47B89DC6.4070906@allied-internet.ag>
Date: Sun, 17 Feb 2008 21:49:10 +0100
From: allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>, jirislaby@gmail.com
Subject: Re: getting uninterruptible sleep processes after upgrade from 2.6.20.20
 to 2.6.24.2
References: <47B892B9.7060205@allied-internet.ag> <alpine.DEB.1.00.0802172133470.6469@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0802172133470.6469@sheep.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 91.3.58.20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >> One week ago we upgraded about 300 servers from 2.6.20.20 to 2.6.24.2.
 >
 > Painfull.

OK not really - i've tested the new kernel on all models. And it works 
fine... the DN state only comes sometimes - absolutely not reproducable. 
So my tests went OK and then we've done the update. I've now seen 5 
servers in 7 days having this problem.

 >> Now we get sometimes dozent of processes in state DN. The system is
 >> completely idle - but the load is 20 or 90 or whatever. And it can
 >> only be "repaired" by rebooting the system.
 >
 > please post sysrq-t (echo t > /proc/sysrq-trigger) output.
Sorry what key is sysrq? Can i also do this via SSH Console?

 > Did you test with *one* server before upgrading all 300? If not, please
 > do and try to upgrade in smaller steps, e.g. 2.6.20->2.6.21 and see when
 > it breaks. Add a few *DEBUG .config options, they may help narrowing
 > down the problem...
Problem here is that it is not reproducable...

Stefan
