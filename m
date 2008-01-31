Return-Path: <linux-kernel-owner+w=401wt.eu-S1761757AbYAaKk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761757AbYAaKk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933428AbYAaKkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:40:14 -0500
Received: from smtp1.kfki.hu ([148.6.0.26]:36941 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163AbYAaKkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:40:10 -0500
Date: Thu, 31 Jan 2008 11:40:04 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Patrick McHardy <kaber@trash.net>, lkml <linux-kernel@vger.kernel.org>,
       Krzysztof Piotr Oledzki <ole@ans.pl>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: cups slow on linux-2.6.24
In-Reply-To: <b6a2187b0801302101l46d614c9y53f798a025b57dc3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com> 
 <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu> 
 <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com> 
 <47A07FEA.3000702@trash.net>  <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>
  <b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com> 
 <47A13573.7090804@trash.net>  <b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>
  <47A13FBD.8050803@trash.net> <b6a2187b0801302101l46d614c9y53f798a025b57dc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Thu, 31 Jan 2008, Jeff Chua wrote:

> On the bad run, I got the following message ...
> 
> boston kernel: nf_ct_tcp: invalid packed ignored IN= OUT=
> SRC=127.0.0.1 DST=127.0.0.1 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=8162
> DF PROTO=TCP SPT=1016 DPT=515 SEQ=3834958843 ACK=0 WINDOW=32792
> RES=0x00 SYN URGP=0 OPT (0204400C0402080A0000CC190000000001030307)
> UID=0 GID=65534

I can't find this packet in the last lo.bad pcap file. Could you dump the 
bad traffic and send it together with the generated log record?

Strange, but there are a lot of incorrect checksum packets. How does it 
come on the loopback interface?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
