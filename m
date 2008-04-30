Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbYD3VXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbYD3VXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761543AbYD3VWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:22:44 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:34716 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834AbYD3VWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:22:43 -0400
X-Greylist: delayed 660 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 17:22:42 EDT
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: kQZGGOseKKcH5E3rcm8zlH0gc71150Hj7XAAqVh9SKvcdPFWusJ2g9WiMpayZEXA+5k=
Message-ID: <4818E08B.4040901@hartkopp.net>
Date: Wed, 30 Apr 2008 23:11:39 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: 2.6.25-git16 fails with "undefined reference to	`compat_mc_getsockopt'"
References: <20080430204622.GA1663@kroah.com>
In-Reply-To: <20080430204622.GA1663@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Don't know if you have seen this or not, but 2.6.25-gi16 seems to fail
> with:
> 	net/built-in.o: In function `ipv6_getsockopt':
> 	(.text+0x6829c): undefined reference to `compat_mc_getsockopt'
>
> I've attached my .config below if that helps any.
>
> thanks,
>
> greg k-h
>   

Hi Greg,

this issue has been already identified and fixed by Pavel Emelyanov:

http://marc.info/?l=linux-netdev&m=120956601217678&w=2

I also had this problem and his fix worked fine for me.

Regards,
Oliver
