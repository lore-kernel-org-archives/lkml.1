Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZLZS6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZLZS6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 13:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZLZS6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 13:58:30 -0500
Received: from mail.vyatta.com ([76.74.103.46]:57672 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZLZS61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 13:58:27 -0500
Date: Sat, 26 Dec 2009 10:58:21 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: netdev@vger.kernel.org
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute 2.6.32 released
Message-ID: <20091226105821.52d36ba8@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version of iproute2 utilities includes the changes necessary to support all the features in
2.6.32, but should be backward compatible with older releases. Lots of bug fixes and little
things, the main area of change is around the always problematic 'ip route flush' interface.

The tar ball is available at:
  http://devresources.linuxfoundation.org/dev/iproute2/download/iproute2-2.6.31.tar.bz2

Repository:
  git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git

For more info on iproute2 see:
  http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

---

Andreas Henriksson (8):
      iproute2: drop equalize support.
      Bug#526329: iproute: Segfault on garbage lladdr
      iproute: typo in ip manpage
      iproute2: use -fPIC in lib/
      iproute: make ss --help output to stdout
      Keep the old tc/ipt/xt module for compatibility.
      Add new (iptables 1.4.5 compatible) tc/ipt/xt module.
      Slightly improve the configure script.

Brian Haley (1):
      ipv6: Add IFA_F_DADFAILED flag

David Ward (2):
      iproute2: Support 20-byte link layer address in idxmap
      iproute2: Add ll_index_to_addr function

Denys Fedoryshchenko (1):
      Filter class output by classid

Eric Dumazet (2):
      ss: correct display of sk pointer
      ss: adds a space before congestion string

Gilad Ben-Yossef (1):
      iproute2 add hoplimit parsing and update usage and documentation

Mark Borst (1):
      iproute: "ip mroute show" doesn't show all output interfaces

Mike Frysinger (5):
      tc/q_atm.so: respect LDFLAGS
      arpd/ifstat/nstat/rtacct: use daemon()
      support static-only systems
      tc: remove dlfcn.h from files that dont need it
      Ignore GDB related files

Olaf Rempel (1):
      iproute2-2.6.14-051107: missing arpd directory

Oliver Hartkopp (2):
      Add support Controller Area Network
      iproute2: add vcan to ip link help text

Patrick McHardy (2):
      iproute uses too small of a receive buffer
      f_fw: fix compat mode

Petr Jediný (1):
      Changing commandline help text to be more uniform...

Sascha Hlusiak (2):
      iptunnel: allow ISATAP with stateless autoconf
      iproute2: ISATAP potential router list

Simon Horman (1):
      flush secondary addresses before primary ones

Srivats P (1):
      ip6tunnel: Fix no default display of ip4ip6 tunnels

Stephen Hemminger (21):
      Fix headers needed for gre
      remove duplicate limits.h
      Remove goto chain
      Add u32 extension to match on ether source/destination
      Add IPV6 match pretty print
      Allow default DP of zero in gred
      fix handling of GRED DPs args
      Fix flushing of large number of entries
      update kernel headers to 2.6.31-rc5
      Fix typo in IPPROTO_DCCP
      add include/linux/if_arp.h
      Update kernel headers to 2.6.31
      Update to 2.6.32 kernel headers
      Consolidate fprintf statements
      Add static-syms.h to ignore
      Add more files to gitignore
      iproute2-091117
      Remove Changes: comments
      Fix warning about strtod() return value
      Fix warning about sprintf() and NSTAT_HIST
      iproute2-091226

Sven Anders (1):
      Fix flushing code - rtnl_send_check

Thomas Egerer (1):
      Fix display of xfrm

Thomas Graf (1):
      cgroup support

Varun Chandramohan (2):
      Add Monitor Support For Neigh Table
      Enable Type Labels For "ip monitor all"

Wolfgang Grandegger (2):
      iproute2: Fixes an issue with cross-compilation
      iproute2: Support for the CAN netlink

jamal (1):
      ip: Allow for easier debug of buggy devices that dont send their names


