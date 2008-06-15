Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYFOOw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYFOOw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 10:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbYFOOwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 10:52:17 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:44271 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757826AbYFOOwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 10:52:16 -0400
Message-ID: <48552C98.1020105@davidnewall.com>
Date: Mon, 16 Jun 2008 00:22:08 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: werner <werner@sys-linux.yi.org>, linux-kernel@vger.kernel.org
Subject: Re: Regressions in the last kernels
References: <1213467969.31034@sys-linux.yi.org> <4854B6D1.2090706@davidnewall.com> <200806151301.42469.rjw@sisk.pl>
In-Reply-To: <200806151301.42469.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 15 of June 2008, David Newall wrote:
>   
>> werner wrote:
>>     
>>> During preparation and own testing for my distro; installation on computers
>>> for neighbours, by reclamations by users, I learned about the following
>>> problems of 2.6.26-rcX :  
>>>
>>> 1) When compiling for i486,  one cannot select/configurate more memory than
>>> 4 GB, menuconfig don't show items with higher values. 
>>>   
>>>       
>> Is not the i486 limited to a 4GB address space?
>>     
>
> The point, if I understand it correctly, is that if you compile the kernel for
> i486 and then run it on something that does support PAE, it will only see
> 4 GB of RAM.

Rather like compiling it for i486 and running it on ia64: you ask for an
i486, you don't get to use features beyond that CPU.
