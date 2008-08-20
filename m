Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYHTShW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYHTShW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYHTShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:37:03 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:45719 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYHTShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ml7CsF8mDnjas70O1tpWwAUb+UrXrTgmkEAa/ImZYWdCOP6EqPtPLZSbEluhWKBwEg
         P98dtAcvqaPC91YsVVR1RY0tNU7NsaXoMi1S2dLX0je8cqns3ZtRiKnk991JETe6Zzl2
         AdenaAk8w4XvZ5oGIpFFdiHlG3uq4N51ooxWM=
Message-ID: <8db1092f0808201136y15a67647i95fd00fb5d2476fc@mail.gmail.com>
Date: Wed, 20 Aug 2008 20:36:57 +0200
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
In-Reply-To: <8db1092f0808160236o63c42de4k3c455c349d3e9da6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
	 <20080812081632.303de380@lxorguk.ukuu.org.uk>
	 <8db1092f0808120107k1f8a65f4sf406fa3a89125870@mail.gmail.com>
	 <200808121645.37539.rjw@sisk.pl>
	 <8db1092f0808130040u25876f45gbb4fa641959f5110@mail.gmail.com>
	 <8db1092f0808160236o63c42de4k3c455c349d3e9da6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/16 Maciej Rutecki <maciej.rutecki@gmail.com>:
> I test few versions of linux kernel and 2.6.26-rc3 hangs during boot,
> 2.6.26-rc2 (propably) is good. I wrote "propably" because bug is not
> 100% reproducible and must have more time to be sure. After I will try
> bisect. Any suggestions?
>
> --
> Maciej Rutecki
> http://www.maciek.unixy.pl
>

I try bisect (no results), and one time I boot kernel with
initcall_debug option. Kernel stops on this:
http://unixy.pl/maciek/download/kernel/dupa/initcall_debug.jpg

I found this threads:
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0805.2/1082.html
http://marc.info/?l=linux-netdev&m=121920792922949&w=2

Seems be similar (maybe I'm wrong).

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
