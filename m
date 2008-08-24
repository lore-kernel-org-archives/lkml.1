Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYHXVX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYHXVX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 17:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYHXVXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 17:23:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54042 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbYHXVXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 17:23:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Date: Sun, 24 Aug 2008 23:27:25 +0200
User-Agent: KMail/1.9.9
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com> <200808221210.59560.rjw@sisk.pl> <8db1092f0808220350wc56af7di5c5e1c2eb2421249@mail.gmail.com>
In-Reply-To: <8db1092f0808220350wc56af7di5c5e1c2eb2421249@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808242327.26863.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of August 2008, Maciej Rutecki wrote:
> 2008/8/22 Rafael J. Wysocki <rjw@sisk.pl>:
> 
> >> http://unixy.pl/maciek/download/kernel/2.6.27-rc3/dmesg-2.6.27-rc3.txt
> >
> > This doesn't look like the same configuration as in the picture you
> > sent previously.  In particular, the ICH7 lines are missing.
> >
> > Thanks,
> > Rafael
> >
> 
> I'm sorry, I boot wrong kernel. This is correct:
> http://unixy.pl/maciek/download/kernel/dupa/dmesg-2.6.26-rc2-initcall_debug.txt

Thanks.

This shows that the crash happens most probably in ide_scan_pcibus(),
before the probing of interfaces.

Rafael
