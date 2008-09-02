Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYIBKAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYIBKAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 06:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYIBJ7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:59:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:10965 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbYIBJ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iqJM/cHznAdwVQbJ2pZgB/2VgdwoRks/c1OgqPeyLVSTc26cVA3jNZYsczMTbU0Prb
         bP8faljEFuOas0a+pHytkKqJT+Fz81vRmXdHo5G4ZY7AKQArOQzKcF7Kt3wdtaACZ1VI
         cKSxd4lEHp1x9DvYxpocZmrWe7lt2dRJeMh8g=
Message-ID: <8db1092f0809020259i91bb979i32ef11ac86e34f1d@mail.gmail.com>
Date: Tue, 2 Sep 2008 11:59:50 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [SOLVED] Re: [2.6.26.*] boot problem (ahci/irq related?)
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <200808242327.26863.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
	 <200808221210.59560.rjw@sisk.pl>
	 <8db1092f0808220350wc56af7di5c5e1c2eb2421249@mail.gmail.com>
	 <200808242327.26863.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I change CONFIG_HZ*. Previous I had CONFIG_HZ=1000, already I have 300:

maciek@gumis:~$ cat /boot/config-2.6.26.2 | grep CONFIG_HZ
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300

If ealier I had boot problem in 2.6.26.2 than now I haven't any
problem with it. Change timer frequency to lower solves problem, but I
don't understand why.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
