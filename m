Return-Path: <linux-kernel-owner+w=401wt.eu-S933634AbXIUWwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbXIUWwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764794AbXIUWdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:33:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41974 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764757AbXIUWdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:33:46 -0400
Message-ID: <46F446C3.9050600@garzik.org>
Date: Fri, 21 Sep 2007 18:33:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Denys Vlasenko <vda.linux@googlemail.com>, Valdis.Kletnieks@vt.edu,
       David Miller <davem@davemloft.net>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
References: <200709211201.24475.vda.linux@googlemail.com>	<200709211905.23946.vda.linux@googlemail.com>	<15775.1190399812@turing-police.cc.vt.edu>	<200709212018.06553.vda.linux@googlemail.com> <20070921220333.3b31afb5@the-village.bc.nu>
In-Reply-To: <20070921220333.3b31afb5@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> For example, bnx2 maintainer says that driver and
>> firmware are closely tied for his driver. IOW: you upgrade kernel
>> and your NIC is not working anymore.
>>
>> Another argument is to make kernel be able to bring up NICs
>> without needing firmware images in initramfs/initrd/hard drive.
> 
> dgrs should be using the request_firmware interface. Actually dgrs is
> probably a good candidate for /dev/null

According to an earlier thread, dgrs was never really maintained, 
written for hardware that was never really distributed widely, and very 
likely hasn't had users in years... if ever.

If that picture is accurate (it's a story I was told), then I am 
definitely queueing up a deletion patch.

	Jeff



