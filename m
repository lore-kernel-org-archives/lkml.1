Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYCQI6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYCQI6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYCQI6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:58:34 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:32461 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYCQI6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:58:34 -0400
Message-ID: <47DE3227.2030802@netone.net.tr>
Date: Mon, 17 Mar 2008 10:56:07 +0200
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
References: <47CE6F66.7020004@netone.net.tr> <47D0895C.5070901@goop.org> <47D0F9D7.8010607@netone.net.tr> <47D172A2.5000408@goop.org> <47D4F250.5000307@netone.net.tr> <47D52B79.7030009@netone.net.tr>
In-Reply-To: <47D52B79.7030009@netone.net.tr>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2008 08:56:44.0550 (UTC) FILETIME=[D3441A60:01C8880C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarkan Erimer wrote:
> Tarkan Erimer wrote:
>> I use Kubuntu's own kernel build via the command "make-kpkg 
>> --revision=1  kernel_image kernel_headers". It fails at the very 
>> early build stage. When issued this command, just after few lines and 
>> then it fails. Today, I will try the same .config with recently 
>> released rc5 and will let know the result.
>>
>
> I tried with .rc5 now and the result is the same. I attached the full 
> error log.

I tried the recently released .rc6 and still the problem is there. I got 
the same error message which is :

echo done >  stamp-debian
echo done >  debian/stamp-conf
====== making target CONFIG-common [new prereqs: stamp-conf]======
This is kernel package version 11.001.
====== making target stamp-arch-conf [new prereqs: CONFIG-common]======

====== making target CONFIG-arch [new prereqs: stamp-arch-conf]======
====== making target conf.vars [new prereqs: Makefile .config]======

Makefile:514: /usr/src/linux-2.6.25-rc6/arch/xen/Makefile: No such file 
or directory
make[1]: *** No rule to make target 
`/usr/src/linux-2.6.25-rc6/arch/xen/Makefile'.  Stop.
make: *** [conf.vars] Error 2



