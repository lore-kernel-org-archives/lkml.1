Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXLWBaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXLWBaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXLWBaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:30:10 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48384 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbXLWBaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:30:09 -0500
Message-ID: <476DBA14.7020603@garzik.org>
Date: Sat, 22 Dec 2007 20:29:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Martin Mares <mj@ucw.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org>	<476D1D16.5090703@garzik.org>	<20071222064719.73fdd9a4@laptopd505.fenrus.org>	<alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>	<mj+md-20071222.192526.25019.nikam@ucw.cz> <20071222121503.3502382a@laptopd505.fenrus.org>
In-Reply-To: <20071222121503.3502382a@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sat, 22 Dec 2007 20:30:58 +0100
> Martin Mares <mj@ucw.cz> wrote:
> 
>> Hello!
>>
>>> Just make it so. The name is fine, the concept is unavoidable. The
>>> people who complain are whiners that haven't ever had to deal with
>>> the fact that there are broken machines around. 
>> I complain as well as the maintainer of the pciutils. Breaking all
>> userspace accesses to extended configuration space just because there
>> is a couple of chipsets
> 
> it's not "just a couple of chipsets", it's actually
> * a whole lot of bioses
> * at least one whole CPU generation
> * ..
> * ..
> 
> Do you really want to code all of that into your userspace access code as well?

That's silly.  He clearly should not have to...   just like he should 
not have to add code to figure out if a device is MMCONFIG-active or not.

MMCONFIG should be all or none.  System vendors sure as hell will not be 
testing this crazy mixed-access model.  System vendors DO test the 
"always off" model, obviously, and the "always on" model is entering 
their testing regime as Vista certification looms and as Linux starts to 
find bugs.

Just Say No to entering "hw vendor never ever tests it this way" land.

	Jeff




