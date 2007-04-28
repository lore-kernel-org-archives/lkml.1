Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXD1ImA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXD1ImA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965584AbXD1Il7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:41:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:32385 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965576AbXD1Il6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=llkXVaYTLhQQCNtgt4QeupCCIiLS+7Z5KXEFpzxvOjBlYmG1yM9iJRA7nlDQWK+tOFARWrl1jvyUlYx1/ho0FpcVpvNK6YN7R0OeCS10imdmIpsf2HHyhZWBLs2xgVkbUYG+8vWMX0sNXslpEJWROUXAZdLCrsL3ueFwXAD3gow=
Message-ID: <5a04609e0704280141u3676c5a5sb8bd54c3a0437bcc@mail.gmail.com>
Date: Sat, 28 Apr 2007 11:41:57 +0300
From: "Sergey Yanovich" <ynvich@gmail.com>
To: "Alex Dubov" <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070428081032.1003.qmail@web36709.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <463242AC.5050608@gmail.com>
	 <20070428081032.1003.qmail@web36709.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What is "modprobe tifm"?

tifm is the name of the "monolithic blob" that I test :).

> What modules have you loaded when it hangs?
>

I believe is the relevant part:
~$ lsmod | grep "mmc\|tifm"
tifm_sd                11272  0
mmc_core               25812  1 tifm_sd
tifm_7xx1               6848  0
tifm_core               9876  2 tifm_sd,tifm_7xx1

Since there are [tifm_*] in lsmod; modprobe tifm is no run.

Can you successfully run this test with -mm tree? I that case
the fault may be hardware related.
