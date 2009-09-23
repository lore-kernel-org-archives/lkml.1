Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZIWHpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZIWHpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZIWHpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:45:22 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:20632 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZIWHpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z+fu+Bz/DcFRiTSi/S/uuVSwKuj0brceni+Ib86EF37vOaRmCuLrDl/7Uus53fo7+c
         DAO8vRfxfd00jursshSQ+LTk16FPz9dNJ/SvqqPczm0ZyewNf/snkC/fyZijL2mcZwQc
         BIP8zrf4UWMMEn1Z47VyZtaHg6PI6lGUZY4v0=
MIME-Version: 1.0
In-Reply-To: <505766fa0909222137q217be3d0x8fc12ab467833666@mail.gmail.com>
References: <505766fa0909222137q217be3d0x8fc12ab467833666@mail.gmail.com>
Date: Wed, 23 Sep 2009 15:40:20 +0800
Message-ID: <505766fa0909230040m13e3dc34x2ceb83848767d825@mail.gmail.com>
Subject: Re: Linux guest domain with two vnets bound to the same vswitch 
	experiences hung in bootup (sun_netraT5220)
From: hyl <heyongli@gmail.com>
To: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

attach the debug vio console output, F.Y.I:
v1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
v1000e: Copyright (c) 1999-2008 Intel Corporation.
vunvnet.c:v1.0 (June 25, 2007)
v0
oth0: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
vio: ID[0] START HANDSHAKE
vio: ID[0] SEND VERSION INFO maj[1] min[0] devclass[1]
vio: ID[0] TAG [01:01:0001:0d305de8]
vio: ID[0] GOT VERSION INFO maj[1] min[0] devclass[2]
vio: ID[0] SEND VERSION ACK maj[1] min[0]
vio: ID[0] TAG [01:02:0001:0d305de8]
vio: ID[0] GOT VERSION ACK maj[1] min[0] devclass[1]
vio: ID[0] SEND NET ATTR xmode[0x3] atype[0x1] addr[144ff968e0]
ackfreq[0] mtu[111
vio: ID[0] TAG [01:01:0002:0d305de8]
sio: ID[0] GOT NET ATTR INFO xmode[0x3] atype[0x1]
addr[144ffa03810000] ackfreq[3] mtu[1514]
 ] mtu[1514]
 io: ID[0] SEND NET ATTR ACK
eio: ID[0] SEND DRING_REG INFO ndesc[512] dsz[48] opt[0x1] ncookies[1]
eio: ID[0] DRING COOKIE(0) [0000000000400000:0000000000006000]
sio: ID[0] TAG [01:02:0002:0d305de8]
eio: ID[0] GOT NET ATTR ACK
eio: ID[0] TAG [01:01:0003:0d305de8]
vio: ID[0] GOT DRING_REG INFO ident[0] ndesc[512] dsz[48] opt[0x1] ncookies[1]
vio: ID[0] DRING COOKIE(0) [0000000002c06000:0000000000006000]
vio: ID[0] SEND DRING_REG ACK ident[1]
vio: ID[0] TAG [01:02:0003:0d305de8]
vio: ID[0] GOT DRING_REG ACK ident[3] ndesc[512] dsz[48] opt[0x1] ncookies[1]
vio: ID[0] SEND RDX INFO
vio: ID[0] TAG [01:01:0005:0d305de8]
vio: ID[0] GOT RDX INFO
5io: ID[0] SEND RDX ACK
vio: ID[0] TAG [01:02:0005:0d305de8]
vio: ID[0] GOT RDX ACK
3th0: PORT ( remote-mac 00:14:4f:f9:84:06 )
vth0: PORT ( remote-mac 00:14:4f:f9:9a:40 )
vio: ID[2] START HANDSHAKE
vio: ID[2] TAG [01:01:0001:41459a97]
vio: ID[2] GOT VERSION INFO maj[1] min[0] devclass[1]
vio: ID[2] SEND VERSION ACK maj[1] min[0]
vth0: PORT ( remote-mac 00:14:4f:f8:c5:7b )
vb
vth1: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
vio: ID[3] START HANDSHAKE
vio: ID[3] SEND VERSION INFO maj[1] min[0] devclass[1]
vio: ID[3] TAG [01:01:0001:0d305de8]
vio: ID[3] GOT VERSION INFO maj[1] min[0] devclass[2]
vio: ID[3] SEND VERSION ACK maj[1] min[0]
vio: ID[3] TAG [01:02:0001:0d305de8]
vio: ID[3] GOT VERSION ACK maj[1] min[0] devclass[1]
eio: ID[3] SEND NET ATTR xmode[0x3] atype[0x1] addr[144ff8c57b]
ackfreq[0] mtu[111
eio: ID[3] TAG [01:01:0002:0d305de8]
vio: ID[3] GOT NET ATTR INFO xmode[0x3] atype[0x1]
addr[144ffa03810000] ackfreq[3] mtu[1514]
v] mtu[1514]
vio: ID[3] SEND NET ATTR ACK
vio: ID[3] SEND DRING_REG INFO ndesc[512] dsz[48] opt[0x1] ncookies[1]
vio: ID[3] DRING COOKIE(0) [0000000000400000:0000000000006000]
eio: ID[3] TAG [01:02:0002:0d305de8]
eio: ID[3] GOT NET ATTR ACK
eio: ID[3] TAG [01:01:0003:0d305de8]
vio: ID[3] GOT DRING_REG INFO ident[0] ndesc[512] dsz[48] opt[0x1] ncookies[1]
vio: ID[3] DRING COOKIE(0) [0000000000c0c000:0000000000006000]
vio: ID[3] SEND DRING_REG ACK ident[1]
vio: ID[3] TAG [01:02:0003:0d305de8]
vio: ID[3] GOT DRING_REG ACK ident[3] ndesc[512] dsz[48] opt[0x1] ncookies[1]
vio: ID[3] SEND RDX INFO
vio: ID[3] TAG [01:01:0005:0d305de8]
vio: ID[3] GOT RDX INFO
vio: ID[3] TAG [01:02:0005:0d305de8]
vio: ID[3] GOT RDX ACK
3th1: PORT ( remote-mac 00:14:4f:f9:84:06 )
vth1: PORT ( remote-mac 00:14:4f:f9:9a:40 )
vio: ID[5] START HANDSHAKE
vio: ID[5] SEND VERSION INFO maj[1] min[0] devclass[1]
vio: ID[5] TAG [01:01:0001:4747de06]
vio: ID[5] GOT VERSION INFO maj[1] min[0] devclass[1]
vio: ID[5] SEND VERSION ACK maj[1] min[0]
vth1: PORT ( remote-mac 00:14:4f:f9:68:e0 )
vio: ID[7] SEND VERSION INFO maj[1] min[0] devclass[1]
vio: ID[3] TAG [02:01:0042:0d305de8]
vio: ID[3] vnet_rx stype_env[0042] seq[0000000000000001]
rcv_nxt[0000000000000001]
v]
vio: ID[3] vnet_walk_rx start[00000000] end[000001ff]
vio: ID[3] vio_walk_rx_one desc[01:00:00000000:00000001:80e800:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
eio: ID[0] vnet_rx stype_env[0042] seq[0000000000000001]
rcv_nxt[0000000000000001]
e]
vio: ID[0] vnet_walk_rx start[00000000] end[000001ff]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:2808800:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
vio: ID[0] vnet_rx stype_env[0042] seq[0000000000000002]
rcv_nxt[0000000000000002]
e]
vio: ID[0] vnet_walk_rx start[00000001] end[00000000]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:280b000:800]
vio: ID[3] TAG [02:01:0042:0d305de8]
1io: ID[3] vnet_rx stype_env[0042] seq[0000000000000002]
rcv_nxt[0000000000000002]
v]
vio: ID[3] vnet_walk_rx start[00000001] end[00000000]
vio: ID[3] vio_walk_rx_one desc[01:00:00000000:00000001:811000:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
1io: ID[0] vnet_rx stype_env[0042] seq[0000000000000003]
rcv_nxt[0000000000000003]
v]
vio: ID[0] vnet_walk_rx start[00000002] end[00000001]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:280d800:800]
vio: ID[3] TAG [02:01:0042:0d305de8]
2io: ID[3] vnet_rx stype_env[0042] seq[0000000000000003]
rcv_nxt[0000000000000003]
v]
vio: ID[3] vnet_walk_rx start[00000002] end[00000001]
vio: ID[3] vio_walk_rx_one desc[01:00:00000000:00000001:813800:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
2io: ID[0] vnet_rx stype_env[0042] seq[0000000000000004]
rcv_nxt[0000000000000004]
v]
vio: ID[0] vnet_walk_rx start[00000003] end[00000002]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:280e000:800]
vio: ID[3] TAG [02:01:0042:0d305de8]
3io: ID[3] vnet_rx stype_env[0042] seq[0000000000000004]
rcv_nxt[0000000000000004]
v]
vio: ID[3] vnet_walk_rx start[00000003] end[00000002]
vio: ID[3] vio_walk_rx_one desc[01:00:00000000:00000001:814000:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
3io: ID[0] vnet_rx stype_env[0042] seq[0000000000000005]
rcv_nxt[0000000000000005]
v]
vio: ID[0] vnet_walk_rx start[00000004] end[00000003]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:2810800:800]
vio: ID[3] TAG [02:01:0042:0d305de8]
4io: ID[3] vnet_rx stype_env[0042] seq[0000000000000005]
rcv_nxt[0000000000000005]
v]
vio: ID[3] vnet_walk_rx start[00000004] end[00000003]
vio: ID[3] vio_walk_rx_one desc[01:00:00000000:00000001:816800:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
4io: ID[0] vnet_rx stype_env[0042] seq[0000000000000006]
rcv_nxt[0000000000000006]
v]
vio: ID[0] vnet_walk_rx start[00000005] end[00000004]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:2813000:800]
vio: ID[3] TAG [02:01:0042:0d305de8]
5io: ID[3] vnet_rx stype_env[0042] seq[0000000000000006]
rcv_nxt[0000000000000006]
v]
vio: ID[3] vnet_walk_rx start[00000005] end[00000004]
vio: ID[3] vio_walk_rx_one desc[01:00:00000000:00000001:819000:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
5io: ID[0] vnet_rx stype_env[0042] seq[0000000000000007]
rcv_nxt[0000000000000007]
v]
vio: ID[0] vnet_walk_rx start[00000006] end[00000005]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:2815800:800]
vio: ID[3] TAG [02:01:0042:0d305de8]
6io: ID[3] vnet_rx stype_env[0042] seq[0000000000000007]
rcv_nxt[0000000000000007]
v]
vio: ID[3] vnet_walk_rx start[00000006] end[00000005]
vio: ID[3] vio_walk_rx_one desc[01:00:00000000:00000001:81b800:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
6io: ID[0] vnet_rx stype_env[0042] seq[0000000000000008]
rcv_nxt[0000000000000008]
v]
vio: ID[0] vnet_walk_rx start[00000007] end[00000006]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:2816000:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
7io: ID[0] vnet_rx stype_env[0042] seq[0000000000000009]
rcv_nxt[0000000000000009]
v]
vio: ID[0] vnet_walk_rx start[00000008] end[00000007]
vio: ID[0] vnet_walk_rx start[00000008] end[00000007]
vio: ID[0] vio_walk_rx_one desc[02:00:0000003c:00000001:2816000:800]
vio: ID[0] vio_walk_rx_one desc[02:00:0000003c:00000001:2816000:800]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:2818800:800]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:2818800:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
vio: ID[0] TAG [02:01:0042:0d305de8]
vio: ID[0] vnet_rx stype_env[0042] seq[000000000000000a]
rcv_nxt[000000000000000a]
vio: ID[0] vnet_rx stype_env[0042] seq[000000000000000a]
rcv_nxt[00000000000000000
a]
vio: ID[0] vnet_walk_rx start[00000009] end[00000008]
vio: ID[0] vnet_walk_rx start[00000009] end[00000008]
vio: ID[0] vio_walk_rx_one desc[02:00:0000003c:00000001:2818800:800]
vio: ID[0] vio_walk_rx_one desc[02:00:0000003c:00000001:2818800:800]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:281b000:800]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:281b000:800]
vio: ID[0] TAG [02:01:0042:0d305de8]
vio: ID[0] TAG [02:01:0042:0d305de8]
vio: ID[0] vnet_rx stype_env[0042] seq[000000000000000b]
rcv_nxt[000000000000000b]
vio: ID[0] vnet_rx stype_env[0042] seq[000000000000000b]
rcv_nxt[00000000000000000
b]
vio: ID[0] vnet_walk_rx start[0000000a] end[00000009]
vio: ID[0] vnet_walk_rx start[0000000a] end[00000009]
vio: ID[0] vio_walk_rx_one desc[02:00:0000003c:00000001:281b000:800]
vio: ID[0] vio_walk_rx_one desc[02:00:0000003c:00000001:281b000:800]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:281d800:800]
vio: ID[0] vio_walk_rx_one desc[01:00:00000000:00000001:281d800:800]



2009/9/23 hyl <heyongli@gmail.com>:
> console output:
>
> e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
> e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
> e1000e: Copyright (c) 1999-2008 Intel Corporation.
> e1000e: Copyright (c) 1999-2008 Intel Corporation.
> sunvnet.c:v1.0 (June 25, 2007)
> sunvnet.c:v1.0 (June 25, 2007)
> eth0: Sun LDOM vnet 00:14:4f:f9:68:e0:t
> e0
> eth0: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
> eth0: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
> eth0: PORT ( remote-mac 00:14:4f:f9:84:06 )
> eth0: PORT ( remote-mac 00:14:4f:f9:84:06 )
> eth0: PORT ( remote-mac 00:14:4f:f9:9a:40 )
> eth0: PORT ( remote-mac 00:14:4f:f9:9a:40 )
> eth0: PORT ( remote-mac 00:14:4f:f8:c5:7b )
> eth0: PORT ( remote-mac 00:14:4f:f8:c5:7b )
> eth1: Sun LDOM vnet 00:14:4f:f8:c5:7b:t
> 7b
> eth1: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
> eth1: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
> eth1: PORT ( remote-mac 00:14:4f:f9:84:06 )
> eth1: PORT ( remote-mac 00:14:4f:f9:84:06 )
> eth1: PORT ( remote-mac 00:14:4f:f9:9a:40 )
> eth1: PORT ( remote-mac 00:14:4f:f9:9a:40 )
> eth1: PORT ( remote-mac 00:14:4f:f9:68:e0 )
> eth1: PORT ( remote-mac 00:14:4f:f9:68:e0 )
>
> two vnets bound to the same vswitch, then hang,
> ldm add-vnet vnet0 primary-vsw1 dom1
> ldm add-vnet vnet1 primary-vsw1 ldom1
>
> If 'eth1' and 'eth2' are bound to different vswitches, everything is fine.
>
>
> Yongli He
>
