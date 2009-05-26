Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbZEZXuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbZEZXuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbZEZXub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:50:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:39882 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841AbZEZXu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:50:29 -0400
Message-ID: <4A1C8091.4050909@kernel.org>
Date: Wed, 27 May 2009 08:51:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       towerlexa@gmx.de
Subject: Re: Who's responsible for configuring CLS on a cardbus device?
References: <4A1BE904.8080302@kernel.org> <20090526142300.73d466d0@lxorguk.ukuu.org.uk> <4A1C7EF9.2030000@gmail.com>
In-Reply-To: <4A1C7EF9.2030000@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 23:50:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Robert Hancock wrote:
> Alan Cox wrote:
>> Currently its handled by pci_set_mwi() but there isn't actually a more
>> direct way to do this.

Thanks Alan.

> Yeah, I guess the assumption is that unless the device is using MWI it
> doesn't care about cache line size. However, in the case of the sata_sil
> controllers (and possibly other devices), the device cares about it for
> other purposes (I think it's FIFO handling in this case).
> 
> Maybe we should just be setting the cache line size somewhere more
> basic, like pci_set_master or something?

Hmmm... given that it is something which is usually handled by the
system firmware, wouldn't it be more fitting to configure it from pci
hotplug code?

Thanks.

-- 
tejun
