Return-Path: <linux-kernel-owner+w=401wt.eu-S937454AbXFGWWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937454AbXFGWWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937104AbXFGWU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:20:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:43587 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936907AbXFGWU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MU7ns/cgaLXx1G4MUehIfWsKhBokWf0G2PFL6FyZKHQcYy7vxGBePQC5SU6uw6JtNw+2GJWGvApzOcADlimWAds1ZTjhYT4gB4pxaI7t8Cj69oPrVXIyryeGTqKayHO0kAnrWg1Bsxarz0gM+7ODoF23pCPKrzOJdeuxBGtNE34=
Message-ID: <d1af83620706071520mdfdb859o57daa16d8732ead7@mail.gmail.com>
Date: Thu, 7 Jun 2007 19:20:55 -0300
From: "Kevin Winchester" <kjwinchester@gmail.com>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: 2.6.22-rc4-mm2 -- ipw2200 -- SIOCSIFADDR: No buffer space available
Cc: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a44ae5cd0706071125p2079472eme52821bd134d26b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0706071125p2079472eme52821bd134d26b0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/07, Miles Lane <miles.lane@gmail.com> wrote:
> Hi Andrew,
>
> This might be some problem with my kernel configuration.
> I added:
> CONFIG_BONDING=y
>
> # dhclient eth1
> There is already a pid file /var/run/dhclient.pid with pid 134993416
> Internet Systems Consortium DHCP Client V3.0.4
> Copyright 2004-2006 Internet Systems Consortium.
> All rights reserved.
> For info, please visit http://www.isc.org/sw/dhcp/
> SIOCSIFADDR: No buffer space available
> Listening on LPF/eth1/00:12:f0:5e:db:2f
> Sending on   LPF/eth1/00:12:f0:5e:db:2f
> Sending on   Socket/fallback
> DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 6
> DHCPOFFER from 192.168.1.1
> DHCPREQUEST on eth1 to 255.255.255.255 port 67
> DHCPACK from 192.168.1.1
> SIOCSIFADDR: No buffer space available
> SIOCSIFNETMASK: Cannot assign requested address
> SIOCSIFBRDADDR: Cannot assign requested address
> SIOCADDRT: Network is unreachable
> bound to 192.168.1.2 -- renewal in 2993 seconds.
>
> # ping www.yahoo.com
> ping: unknown host www.yahoo.com
>
> Any suggestions what to try now?  I'll go ahead and turn off the
> bonding option and see if that helps.
>

I was seeing this same error last night on my via-velocity based
ethernet interface.  I chalked it up to some config mistake on my
part, but I guess there might be more to it.  Whatever it is, it
doesn't seem to be specific to the ipw2200 driver.

-- 
Kevin Winchester
