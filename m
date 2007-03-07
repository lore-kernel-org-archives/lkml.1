Return-Path: <linux-kernel-owner+w=401wt.eu-S1161256AbXCGDxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161256AbXCGDxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 22:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161257AbXCGDxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 22:53:42 -0500
Received: from ipmail02.adl2.internode.on.net ([203.16.214.141]:8639 "EHLO
	ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161256AbXCGDxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 22:53:41 -0500
X-IronPort-AV: i="4.14,256,1170595800"; 
   d="scan'208"; a="94158003:sNHT2248357174"
Message-ID: <45EE373B.80606@iinet.net.au>
Date: Wed, 07 Mar 2007 14:53:31 +1100
From: Ben Nizette <ben.nizette@iinet.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070305)
MIME-Version: 1.0
To: NZG <ngustavson@emacinc.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: passing function pointers through platform devices?
References: <200703061246.29615.ngustavson@emacinc.com>
In-Reply-To: <200703061246.29615.ngustavson@emacinc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NZG wrote:
> I'm developing an SPI- bus >MMC/SD block driver translation layer.
> As part of this layer the write protect and card detect lines need to be read.
> The method for determining the state of these lines will be board specific.
> 
> Is it appropriate to pass a function pointer through a platform device 
> (declared in the mach initialization) to implement card_available and 
> write_protect function calls?
> Or is there a cleaner way to do it?

Once the generic GPIO framework migrates upstream from -mm you should 
just pass the GPIO token from board-specific code and gpio_get_value() it.

--Ben.
