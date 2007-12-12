Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbXLLAPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbXLLAPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbXLLAO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:14:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:52222 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbXLLAOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:14:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GAZRUaTtr3WRaYdNpLoElfEzGZvh6urMRSRPtGX4SwiprGp7ixYvEaunzONFn2TeUAOOcWQg5iFJLgJh+XWEMmRGr8/n2vR96ta8HQarRRPgEEwHkaMcJE+o++5B2cmRTuHuP38Tt/DVPcfyWv2wQLxx5r9I04EFV1TKfd4kYRU=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFT] Port 0x80 I/O speed
Date: Wed, 12 Dec 2007 02:14:21 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
References: <475F1DC6.5090403@keyaccess.nl> <200712120140.34697.maximlevitsky@gmail.com> <475F20EA.5050803@keyaccess.nl>
In-Reply-To: <475F20EA.5050803@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712120214.21346.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2007 01:44:42 Rene Herman wrote:
> On 12-12-07 00:40, Maxim Levitsky wrote:
> 
> > maxim@MAIN:~/tmp$ sudo ./port800
> > cycles: out 1767, in 1147
> > maxim@MAIN:~/tmp$ sudo ./port800
> > cycles: out 1774, in 1148
> > maxim@MAIN:~/tmp$ sudo ./port800
> > cycles: out 1769, in 1150
> > maxim@MAIN:~/tmp$ sudo ./port800
> > cycles: out 1769, in 1150
> > maxim@MAIN:~/tmp$ sudo ./port800
> > cycles: out 1777, in 1150
> > maxim@MAIN:~/tmp$ sudo ./port800
> > cycles: out 1766, in 1149
> > maxim@MAIN:~/tmp$ sudo ./port800
> > cycles: out 1768, in 1148
> > maxim@MAIN:~/tmp$ sudo ./port800
> > cycles: out 1765, in 1147
> > 
> > 
> > Core 2 Duo system (ICH8/Intel DG965RY motherboard)
> 
> 1.8 Ghz?
> 
> Rene.
> 
> 

2.1 GHZ. but usually reduced by EIST to 1.5 GHz
(It can have just two values above)

I did the tests again:


CPU frequency locked to 2128.000 Mhz:
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1650, in 1065
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1648, in 1066
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1649, in 1065
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1648, in 1065
maxim@MAIN:~/tmp$


CPU frequency locked to: 1596.000 Mhz
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1730, in 1138
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1730, in 1138
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1735, in 1140
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1734, in 1139
maxim@MAIN:~/tmp$ sudo ./port800
cycles: out 1734, in 1138
maxim@MAIN:~/tmp$ 2128.000    


A bit strange, isn't it?
Regards,
	Maxim Levitsky
