Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbZCXMXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbZCXMXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZCXMXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:23:36 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:46930 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZCXMXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:23:35 -0400
Date: Tue, 24 Mar 2009 13:23:31 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Re: tg3 driver fails to load firmware (2.6.29)
Message-ID: <20090324122331.GT12613@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20090324120948.GO12613@charite.de> <49C8D09A.2010006@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C8D09A.2010006@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Tokarev <mjt@tls.msk.ru>:
> Ralf Hildebrandt wrote:
>> From the log:
>>
>> Mar 24 09:02:42 proxy-cvk-2 kernel: [   40.600196] tg3 0000:02:02.1: firmware: requesting tigon/tg3_tso.bin
>> Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599130] eth1: Failed to load firmware "tigon/tg3_tso.bin"
>
>> # ll /lib/firmware/2.6.29/tigon/tg3_tso.bin
>> -rw-r--r-- 1 root root 7004 Mar 24 09:24 /lib/firmware/2.6.29/tigon/tg3_tso.bin
>
> Shouldn't it be in /lib/firmware/tigon/tg3_tso.bin ?

Well, who knows...

proxy-cvk-1:/lib/firmware# cp -a 2.6.29/tigon .  
proxy-cvk-1:/lib/firmware# ll
total 12
drwxr-xr-x 3 root root 4096 Mar 24 09:24 2.6.29
drwxr-xr-x 3 root root 4096 Mar 17 16:31 2.6.29-rc8-git2
drwxr-xr-x 2 root root 4096 Mar 24 09:24 tigon

Let's see if that work.s
-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12200 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  Ralf.Hildebrandt@charite.de | http://www.charite.de
