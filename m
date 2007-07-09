Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbXGIWkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbXGIWkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXGIWkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:40:31 -0400
Received: from mbox1.netikka.net ([213.250.81.202]:55591 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbXGIWk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:40:29 -0400
Message-ID: <4692B95A.2020400@mandriva.org>
Date: Tue, 10 Jul 2007 01:40:26 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Problem with SiS Ide/Pata/Sata on 2.6.22-rc7-git4
References: <4692A7C3.9030802@mandriva.org> <20070709232742.004def28@the-village.bc.nu>
In-Reply-To: <20070709232742.004def28@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox skrev:
>> If you modprobe only sis5513
>>   OR
>> If you modprobe only sis5513 and then sata_sis/pata_sis:
>>   - you get this:
>>     (the hdb drive does not get detected/usable)
> 
> Don't mix old and new IDE like that. We allow both so you can use old SIS
> and new Jmicron etc for example but there are some cases where trying to
> load both old and new IDE support for the same chip will do strange
> things.
> 
> Alan
> 
> 

So this means that if you want to use pata & sata disks connected to sis 
chipset you cant use sis5513 at all, if I understand this correct?

If that's the case I guess we simply have to blacklist (or stop 
building) the sis5513 and force all sis ide users to pata_sis...

Now, do you consider pata_sis as stable as the sis5513 ?

--
Thomas
