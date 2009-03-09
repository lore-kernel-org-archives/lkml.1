Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZCIBT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZCIBT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 21:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZCIBTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 21:19:22 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:52682 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZCIBTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 21:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=a5cJ7dXZdGojLCX/QUowFexq7CO1EvKswsU7MZmP+yjszLcrbEn2WnYeAtUl8158Kj
         KOr4TdGy1GNE3X75CqHs+9yw7ZbGCLxBSuwoM8pTvyp4wM6H+Tf3KJ+T94MK/9T8T1Yr
         1disiCU+aUjOedBoMPyTkfcZ/wE1e3mIFH9Tc=
Message-ID: <49B46E8D.6020702@gmail.com>
Date: Sun, 08 Mar 2009 21:19:09 -0400
From: Weedy <weedy2887@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090211)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Fwd: Re: [Openswan Users] Cannot get NETKEY working on openwrt ERROR:
 netlink XFRM_MSG_NEWPOLICY]
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-------- Original Message --------
Subject: Re: [Openswan Users] Cannot get NETKEY working on openwrt
ERROR: netlink XFRM_MSG_NEWPOLICY
Date: Sun, 8 Mar 2009 20:02:27 -0400 (EDT)
From: Paul Wouters <paul@xelerance.com>
To: Weedy <weedy2887@gmail.com>
References: <49B38FE8.6060700@gmail.com>
<Pine.LNX.4.64.0903081916370.19531@newtla.xelerance.com>
<49B459AB.7020300@gmail.com>

On Sun, 8 Mar 2009, Weedy wrote:

Then I'm not sure what's wrong with that kernel.

Paul

> Date: Sun, 08 Mar 2009 19:50:03 -0400
> From: Weedy <weedy2887@gmail.com>
> To: Paul Wouters <paul@xelerance.com>
> Subject: Re: [Openswan Users] Cannot get NETKEY working on openwrt ERROR:
>     netlink XFRM_MSG_NEWPOLICY
> 
> Paul Wouters wrote:
> > On Sun, 8 Mar 2009, Weedy wrote:
> > 
> >> Openwrt - Linux Openswan U2.4.13/K2.6.28.7 (netkey)
> >> pluto[6262]: "pom" #4: ERROR: netlink response for Add SA
> >> esp.623130a2@1.2.3.4 included errno 2: No such file or directory
> > 
> >> I have tried to sync the kernel config as best as possible for all IPsec
> >> related options but to no avail, any hints would be much appreciated.
> >> (Between the gentoo box and a centos test box it works fine, so I know I
> >> have the configs working and the kernel setup properly)
> > 
> > Are you using the real "ip" command, and not the limitel broken "ip"
> > command from busybox?
> > 
> > Paul
> 
>  make[3] -C package/iproute2 compile
> --2009-03-08 19:21:48--
> http://devresources.linux-foundation.org/dev/iproute2/download/iproute2-2.6.28.tar.bz2
> 
> root@cbarone:~# ip -V
> ip utility, iproute2-ss090115
> 

I'm posting this in hopes that someone more familiar with this area of
the kernel can tell me what the error message means, or what direction I
should go from here.

Openwrt - Linux Openswan U2.4.13/K2.6.28.7 (netkey)
pluto[6262]: "pom" #4: ERROR: netlink response for Add SA
esp.623130a2@1.2.3.4 included errno 2: No such file or directory

Gentoo - Linux Openswan U2.4.13/K2.6.28-gentoo-r2 (netkey)
pluto[12367]: "cbarone" #5: ERROR: netlink XFRM_MSG_NEWPOLICY response
for flow tun.10000@4.3.2.1 included errno 17: File exists

openwrt modules: aes_generic af_key ah4 arc4 authenc cbc deflate
des_generic ecb esp4 hmac ipcomp ipt_ah md5 sha1_generic xfrm4_mode_beet
xfrm4_mode_transport xfrm4_mode_tunnel xfrm4_tunnel xfrm_ipcomp
xfrm_user xt_esp
