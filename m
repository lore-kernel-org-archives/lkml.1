Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYHPJgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYHPJgY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 05:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYHPJgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 05:36:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:43731 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYHPJgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 05:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hN2xDnyQBghrW/bkH6BNG2SL4Oj4YO2QOi6yDeXtSRVUWD5CvSsUXEM/8mYmUj52Mb
         5GQm7MzgbybUOZ/eDHzN7J9AV61AHNW5uVG87puPQvV7eWGTFam4Bic+yVRA76M4AYkU
         ZvtBJ0Ln+XRxOdHNSXFWtc1Ano7INRFhuFeqY=
Message-ID: <8db1092f0808160236o63c42de4k3c455c349d3e9da6@mail.gmail.com>
Date: Sat, 16 Aug 2008 11:36:13 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <8db1092f0808130040u25876f45gbb4fa641959f5110@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
	 <20080812081632.303de380@lxorguk.ukuu.org.uk>
	 <8db1092f0808120107k1f8a65f4sf406fa3a89125870@mail.gmail.com>
	 <200808121645.37539.rjw@sisk.pl>
	 <8db1092f0808130040u25876f45gbb4fa641959f5110@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I test few versions of linux kernel and 2.6.26-rc3 hangs during boot,
2.6.26-rc2 (propably) is good. I wrote "propably" because bug is not
100% reproducible and must have more time to be sure. After I will try
bisect. Any suggestions?

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
