Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZI3Mds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZI3Mds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZI3Mds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:33:48 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:42537 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZI3Mdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:33:47 -0400
Date: Wed, 30 Sep 2009 14:33:49 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31: WARNING: at net/ipv4/af_inet.c:154
 inet_sock_destruct+0x164/0x1c0()
Message-ID: <20090930123349.GE17974@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20090930122441.GB17974@charite.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090930122441.GB17974@charite.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>:
> This machine runs openvpn:
> 
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259235] ------------[ cut here ]------------
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259246] WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct+0x164/0x1c0()
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259249] Hardware name: ProLiant DL360 G4p
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259251] Modules linked in: ipt_REJECT ipt_LOG xt_multiport tun xt_tcpudp xt_state iptable_nat nf_nat iptable_filter ip_tables x_tables nf_conntrack_ipv4 nf_defrag_ipv4 ipv6 psmouse nf_conntrack_ftp nf_conntrack tg3 libphy
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259274] Pid: 2286, comm: openvpn Not tainted 2.6.31 #1
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259276] Call Trace:
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259282]  [<c126d154>] ? inet_sock_destruct+0x164/0x1c0
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259288]  [<c10326fb>] ? warn_slowpath_common+0x6f/0xcd
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259292]  [<c126d154>] ? inet_sock_destruct+0x164/0x1c0
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259296]  [<c1032779>] ? warn_slowpath_null+0x20/0x3c
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259300]  [<c126d154>] ? inet_sock_destruct+0x164/0x1c0
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259305]  [<c128bdcb>] ? _spin_lock_bh+0x16/0x40
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259309]  [<c128bdcb>] ? _spin_lock_bh+0x16/0x40
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259314]  [<c121bc78>] ? __sk_free+0x21/0xd6
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259318]  [<c121be41>] ? sk_common_release+0x5b/0x97
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259321]  [<c126cc05>] ? inet_release+0x39/0x66
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259325]  [<c1218eaa>] ? sock_release+0x22/0x8d
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259329]  [<c1218f31>] ? sock_close+0x1c/0x42
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259334]  [<c10a125c>] ? __fput+0xd6/0x1e0
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259338]  [<c109dd34>] ? filp_close+0x41/0x72
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259342]  [<c109ddda>] ? sys_close+0x75/0xc0
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259347]  [<c1002ecf>] ? sysenter_do_call+0x12/0x26
> Sep 30 08:48:05 vpn-gw-int kernel: [1706466.259350] ---[ end trace 4715d461fc27d993 ]---

This bug can also be found here:
http://bugzilla.kernel.org/show_bug.cgi?id=14002
