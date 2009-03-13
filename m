Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZCMHoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZCMHoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZCMHo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:44:27 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40182 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260AbZCMHo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:44:27 -0400
X-Sasl-enc: wOqZYzs6ri59yaxesRENgrUhu19T+p3j71EFRt3+LKiF 1236930264
Message-ID: <49BA0EDA.4080606@ladisch.de>
Date: Fri, 13 Mar 2009 08:44:26 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Christian P. Schmidt" <schmidt@digadd.de>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] How can PCI resource allocation fail?
References: <49B9959F.1080705@digadd.de>
In-Reply-To: <49B9959F.1080705@digadd.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian P. Schmidt wrote:
> I'm toying with the alsa-driver for the Creative Labs X-Fi. I'm working
> on the PCI Express version of this card,

... which isn't supported ...

> [46833.487588] cannot allocate the port
> [46833.487594] CA0106: probe of 0000:04:00.0 failed with error -16
> ...
> 	Region 0: Memory at f9ffc000 (32-bit, non-prefetchable) [size=16K]

... because this I/O range is memory-mapped; the driver knows only about
models with regular I/O ports.  (This has nothing to do with the PCI-E
bridge; the X-Fi chip itself is a different model.)


Best regards,
Clemens
