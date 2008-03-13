Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYCMMzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYCMMzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYCMMz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:55:28 -0400
Received: from smtpout04-01.prod.mesa1.secureserver.net ([64.202.165.196]:34180
	"HELO smtpout04-02.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752972AbYCMMz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:55:27 -0400
Message-ID: <47D9243E.8000501@seclark.us>
Date: Thu, 13 Mar 2008 08:55:26 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: Is there a wireless PCI/e card that is supported in the kernel?
References: <alpine.DEB.1.00.0803130827490.18866@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.00.0803130827490.18866@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> In the past, I used ndiswrapper etc but noticed that would freeze up 
> my laptop occasionally..
>
> Obviously for a server machine if you are going to add a wireless card 
> you /probably/ do not want to be using ndiswrapper if it is an 
> important host.
>
> PCI-e: (D-Link DWA-556)
> http://www.newegg.com/Product/Product.aspx?Item=N82E16833127218
>
> PCI Cards:
> This one seems to be the most popular one on newegg:
> EDIMAX EW-7128G IEEE 802.11b/g PCI Wireless Card Up to 54Mbps Data 
> Rates 64/128-Bit WEP, 802.1x, WPA, AES - Retail
> http://www.newegg.com/Product/ProductReview.aspx?Item=N82E16833315041
> Pros: Ubuntu 7.10 (Gusty Gibbon) picked up this card without any need 
> for additional drivers. It has been running with 85% signal stregnth 
> with the router in the next room.
> But then:
> Cons: Drivers are still under development. The rt2x00 driver is in the 
> 2.6.24 kernel, but it's somewhat buggy. Kernels built from the rt2x00 
> devel tree do work significantly better. Regardless of the kernel that 
> I tried, I was unable to put the card into master mode (for creating 
> an access point).
>
> GIGABYTE GN-WP01GS IEEE 802.11b/g PCI Wireless Adapter Up to 54Mbps 
> Data Rates 64/128 bit WEP, WPA, 802.1x, AES - Retail
> http://www.newegg.com/Product/Product.aspx?Item=N82E16839121008
> Pros: Just dropped it in and it works in 2.6.22-14 Ubuntu Gutsy x86 
> (just tested WEP though). This was researched before purchase. Ralink 
> open sourced their drivers and the rt61pci driver is part modern 
> kernels. Very good price.
>
> D-Link DWL-AG530 IEEE 802.11a/b/g 32-bit PCI Wireless Adapter Up to 
> 108Mbps Data Rates 64-, 128-, 152-WEP 802.1x WPA.Wi-Fi Protected 
> Access (64-, 128-WEP with TKIP, MIC, IV Expansion, Shared Key 
> Authentication Supports Advanced Encrypti - Retail
> Good reviews, but nobody mentions Linux.
> http://www.newegg.com/Product/Product.aspx?Item=N82E16833127136
>
> Any comments or success stories of GOOD working cards without the use 
> of ndiswrapper?
>
> Justin.
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
I have an intel 3945 mini pci card in my laptop that works well and is 
dircctly supported in the kernel. I would look for a card that has a
chipset directly supported by the vendor which intel does.

My $.02
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



