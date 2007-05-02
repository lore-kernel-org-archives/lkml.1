Return-Path: <linux-kernel-owner+w=401wt.eu-S1422627AbXEBVPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422627AbXEBVPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423508AbXEBVPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:15:37 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35296 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422627AbXEBVPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:15:35 -0400
X-Originating-Ip: 72.143.66.196
Date: Wed, 2 May 2007 17:15:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead CONFIG_ variables:  net/ipv4/
Message-ID: <Pine.LNX.4.64.0705021711450.16967@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  again, this list contains some CONFIG_ variables that aren't
technically dead, but *really* should be renamed to not be confused
with Kconfig variables.  there are, however, legitimately dead ones in
the following in places:

$ ../dead_config.sh net/ipv4
========== IP_FIB_TRIE_STATS ==========
net/ipv4/fib_trie.c:#undef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
net/ipv4/fib_trie.c:#endif /*  CONFIG_IP_FIB_TRIE_STATS */
========== IP_NF_NAT ==========
net/ipv4/netfilter/Kconfig:# If they want FTP, set to $CONFIG_IP_NF_NAT (m or y),
net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c:#if !defined(CONFIG_IP_NF_NAT) && !defined(CONFIG_IP_NF_NAT_MODULE)
net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c:#if !defined(CONFIG_IP_NF_NAT) && !defined(CONFIG_IP_NF_NAT_MODULE)
========== IP_NOSIOCRT ==========
net/ipv4/fib_frontend.c:#ifndef CONFIG_IP_NOSIOCRT
========== IP_PIMSM ==========
net/ipv4/ipmr.c:#define CONFIG_IP_PIMSM 1
net/ipv4/ipmr.c:#ifdef CONFIG_IP_PIMSM
net/ipv4/ipmr.c:#ifdef CONFIG_IP_PIMSM
net/ipv4/ipmr.c:#ifdef CONFIG_IP_PIMSM
net/ipv4/ipmr.c:#ifdef CONFIG_IP_PIMSM
net/ipv4/ipmr.c:#ifdef CONFIG_IP_PIMSM
net/ipv4/ipmr.c:#ifdef CONFIG_IP_PIMSM
net/ipv4/ipmr.c:#ifdef CONFIG_IP_PIMSM
net/ipv4/ipmr.c:#ifdef CONFIG_IP_PIMSM
net/ipv4/ipmr.c:#ifdef CONFIG_IP_PIMSM
net/ipv4/ipmr.c:#ifdef CONFIG_IP_PIMSM
========== IP_ROUTE_PERVASIVE ==========
net/ipv4/fib_semantics.c:#ifdef CONFIG_IP_ROUTE_PERVASIVE
========== IP_VS_DH_TAB_BITS ==========
net/ipv4/ipvs/ip_vs_dh.c:#ifndef CONFIG_IP_VS_DH_TAB_BITS
net/ipv4/ipvs/ip_vs_dh.c:#define CONFIG_IP_VS_DH_TAB_BITS        8
net/ipv4/ipvs/ip_vs_dh.c:#define IP_VS_DH_TAB_BITS               CONFIG_IP_VS_DH_TAB_BITS
net/ipv4/ipvs/ip_vs_dh.c:#define IP_VS_DH_TAB_BITS               CONFIG_IP_VS_DH_TAB_BITS
net/ipv4/ipvs/ip_vs_dh.c:#define IP_VS_DH_TAB_SIZE               (1 << IP_VS_DH_TAB_BITS)
========== IP_VS_LBLCR_DEBUG ==========
net/ipv4/ipvs/ip_vs_lblcr.c:#ifdef CONFIG_IP_VS_LBLCR_DEBUG
net/ipv4/ipvs/ip_vs_lblcr.c:#ifdef CONFIG_IP_VS_LBLCR_DEBUG
net/ipv4/ipvs/ip_vs_lblcr.c:#ifdef CONFIG_IP_VS_LBLCR_DEBUG
net/ipv4/ipvs/ip_vs_lblcr.c:#ifdef CONFIG_IP_VS_LBLCR_DEBUG
========== IP_VS_LBLCR_TAB_BITS ==========
net/ipv4/ipvs/ip_vs_lblcr.c:#ifndef CONFIG_IP_VS_LBLCR_TAB_BITS
net/ipv4/ipvs/ip_vs_lblcr.c:#define CONFIG_IP_VS_LBLCR_TAB_BITS      10
net/ipv4/ipvs/ip_vs_lblcr.c:#define IP_VS_LBLCR_TAB_BITS     CONFIG_IP_VS_LBLCR_TAB_BITS
net/ipv4/ipvs/ip_vs_lblcr.c:#define IP_VS_LBLCR_TAB_BITS     CONFIG_IP_VS_LBLCR_TAB_BITS
net/ipv4/ipvs/ip_vs_lblcr.c:#define IP_VS_LBLCR_TAB_SIZE     (1 << IP_VS_LBLCR_TAB_BITS)
========== IP_VS_LBLC_TAB_BITS ==========
net/ipv4/ipvs/ip_vs_lblc.c:#ifndef CONFIG_IP_VS_LBLC_TAB_BITS
net/ipv4/ipvs/ip_vs_lblc.c:#define CONFIG_IP_VS_LBLC_TAB_BITS      10
net/ipv4/ipvs/ip_vs_lblc.c:#define IP_VS_LBLC_TAB_BITS     CONFIG_IP_VS_LBLC_TAB_BITS
net/ipv4/ipvs/ip_vs_lblc.c:#define IP_VS_LBLC_TAB_BITS     CONFIG_IP_VS_LBLC_TAB_BITS
net/ipv4/ipvs/ip_vs_lblc.c:#define IP_VS_LBLC_TAB_SIZE     (1 << IP_VS_LBLC_TAB_BITS)
========== IP_VS_SH_TAB_BITS ==========
net/ipv4/ipvs/ip_vs_sh.c:#ifndef CONFIG_IP_VS_SH_TAB_BITS
net/ipv4/ipvs/ip_vs_sh.c:#define CONFIG_IP_VS_SH_TAB_BITS        8
net/ipv4/ipvs/ip_vs_sh.c:#define IP_VS_SH_TAB_BITS               CONFIG_IP_VS_SH_TAB_BITS
net/ipv4/ipvs/ip_vs_sh.c:#define IP_VS_SH_TAB_BITS               CONFIG_IP_VS_SH_TAB_BITS
net/ipv4/ipvs/ip_vs_sh.c:#define IP_VS_SH_TAB_SIZE               (1 << IP_VS_SH_TAB_BITS)

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
