Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbXC3K5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbXC3K5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 06:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933564AbXC3K5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 06:57:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbXC3K5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 06:57:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc5-mm3
Date: Fri, 30 Mar 2007 13:00:12 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
In-Reply-To: <20070330010559.2a232d9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703301300.12812.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 30 March 2007 10:05, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/
> 
> - git-cryptodev has things in it again
> 
> - Re-added git-e1000: a large amount of e1000 driver work
> 
> - git-net has a huge amount of material in it, but I dropped it because it
>   went oops.
> 
> - git-block is back, minus the problematic unplugging rework.
> 
> - Lots of x86 updates.
> 
> - lguest is being redone and has been dropped
> 
> - The IDE development tree has been restored

On my system (x86_64) 'make install_modules' produces a lot of warning messages:

if [ -r System.map -a -x /sbin/depmod ]; then /sbin/depmod -ae -F System.map  2.6.21-rc5-mm3; fi
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol __nf_ct_l4proto_find
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_conntrack_find_get
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_conntrack_l4proto_register
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_conntrack_l4proto_udp6
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_conntrack_checksum
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol __nfa_fill
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_ct_get_tuple
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol __nf_ct_event_cache_init
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_conntrack_l3proto_register
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_ct_log_invalid
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_conntrack_l4proto_tcp6
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol need_conntrack
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_conntrack_l4proto_unregister
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol per_cpu__nf_conntrack_stat
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol __nf_conntrack_confirm
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_ct_invert_tuple
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol per_cpu__nf_conntrack_ecache
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_conntrack_l3proto_unregister
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_ct_deliver_cached_events
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol __nf_ct_refresh_acct
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko needs unknown symbol nf_conntrack_in
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_rt.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_rt.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_owner.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_owner.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_mh.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_mh.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_ipv6header.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_ipv6header.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_hl.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_hl.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_hbh.ko needs unknown symbol xt_unregister_matches
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_hbh.ko needs unknown symbol xt_register_matches
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_frag.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_frag.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_eui64.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_eui64.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_ah.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_ah.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_REJECT.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_REJECT.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_LOG.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_LOG.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_HL.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6t_HL.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_free_table_info
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_find_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_alloc_table_info
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_check_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_register_table
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_proto_init
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_replace_table
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_find_table_lock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_table_unlock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_proto_fini
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_check_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_find_revision
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_unregister_table
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_find_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv6/netfilter/ip6_tables.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_tftp.ko needs unknown symbol nf_conntrack_expect_related
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_tftp.ko needs unknown symbol nf_nat_tftp_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_snmp_basic.ko needs unknown symbol nf_conntrack_helper_unregister
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_snmp_basic.ko needs unknown symbol nf_conntrack_helper_register
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_sip.ko needs unknown symbol nf_nat_sdp_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_sip.ko needs unknown symbol nf_conntrack_expect_related
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_sip.ko needs unknown symbol nf_nat_sip_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_sip.ko needs unknown symbol nf_conntrack_unexpect_related
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_sip.ko needs unknown symbol ct_sip_get_info
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_pptp.ko needs unknown symbol nf_nat_pptp_hook_exp_gre
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_pptp.ko needs unknown symbol nf_conntrack_expect_find_get
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_pptp.ko needs unknown symbol nf_nat_pptp_hook_inbound
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_pptp.ko needs unknown symbol nf_nat_pptp_hook_outbound
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_pptp.ko needs unknown symbol nf_conntrack_expect_put
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_pptp.ko needs unknown symbol nf_nat_pptp_hook_expectfn
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_pptp.ko needs unknown symbol nf_conntrack_unexpect_related
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_irc.ko needs unknown symbol nf_conntrack_expect_related
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_irc.ko needs unknown symbol nf_nat_irc_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_irc.ko needs unknown symbol nf_conntrack_unexpect_related
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol nat_callforwarding_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol nat_t120_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol set_h225_addr_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol set_ras_addr_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol nat_q931_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol nat_rtp_rtcp_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol nf_conntrack_expect_related
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol nf_conntrack_unexpect_related
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol set_sig_addr_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol get_h225_addr
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol nat_h245_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_h323.ko needs unknown symbol set_h245_addr_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_ftp.ko needs unknown symbol nf_nat_ftp_hook
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_ftp.ko needs unknown symbol nf_conntrack_expect_related
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat_ftp.ko needs unknown symbol nf_conntrack_unexpect_related
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol __nf_ct_l4proto_find
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_ct_invert_tuplepr
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_ct_l3proto_put
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol __nfa_fill
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_conntrack_tcp_update
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_ct_get_tuple
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_conntrack_untracked
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_ct_l3proto_find_get
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_conntrack_tuple_taken
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_conntrack_htable_size
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_ct_iterate_cleanup
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_conntrack_alter_reply
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_nat.ko needs unknown symbol nf_conntrack_destroyed
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol __nf_ct_l4proto_find
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_find_get
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_l4proto_register
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_checksum
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol __nfa_fill
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_ct_get_tuple
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_l4proto_udp4
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol __nf_ct_event_cache_init
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_l3proto_register
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_max
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_ct_log_invalid
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_ct_l3protos
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol need_conntrack
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_htable_size
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_expect_list
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_l4proto_unregister
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol per_cpu__nf_conntrack_stat
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_count
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol __nf_conntrack_confirm
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_ct_invert_tuple
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol print_tuple
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol per_cpu__nf_conntrack_ecache
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_lock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_l3proto_unregister
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_l4proto_tcp4
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_ct_deliver_cached_events
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_hash
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol __nf_ct_refresh_acct
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_l3proto_generic
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko needs unknown symbol nf_conntrack_in
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/iptable_nat.ko needs unknown symbol nf_conntrack_untracked
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/iptable_nat.ko needs unknown symbol need_conntrack
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/iptable_nat.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/iptable_nat.ko needs unknown symbol nf_conntrack_unregister_cache
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/iptable_nat.ko needs unknown symbol nf_conntrack_register_cache
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/iptable_nat.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_ttl.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_ttl.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_tos.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_tos.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_recent.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_recent.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_owner.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_owner.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_iprange.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_iprange.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_ecn.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_ecn.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_ah.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_ah.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_addrtype.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_addrtype.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_ULOG.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_ULOG.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_TTL.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_TTL.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_TOS.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_TOS.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_SAME.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_SAME.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_REJECT.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_REJECT.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_REDIRECT.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_REDIRECT.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_NETMAP.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_NETMAP.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_MASQUERADE.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_MASQUERADE.ko needs unknown symbol nf_ct_iterate_cleanup
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_MASQUERADE.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_LOG.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_LOG.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_ECN.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_ECN.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko needs unknown symbol nf_ct_l3proto_module_put
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko needs unknown symbol nf_ct_l3proto_try_module_get
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_compat_unlock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_free_table_info
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_register_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_find_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_alloc_table_info
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_check_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_compat_match_from_user
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_unregister_match
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_compat_target_from_user
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_compat_match_to_user
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_register_table
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_proto_init
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_replace_table
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_find_table_lock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_compat_target_offset
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_table_unlock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_proto_fini
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_compat_target_to_user
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_compat_match_offset
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_check_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_find_revision
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_compat_lock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_unregister_table
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_find_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/ip_tables.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arpt_mangle.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arpt_mangle.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_free_table_info
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_alloc_table_info
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_register_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_register_table
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_proto_init
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_replace_table
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_find_table_lock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_table_unlock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_proto_fini
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_check_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_find_revision
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_unregister_table
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_find_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/net/ipv4/netfilter/arp_tables.ko needs unknown symbol xt_unregister_target
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol xdr_decode_string_inplace
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol rpc_shutdown_client
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol auth_domain_find
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_recv
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol xdr_inline_decode
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_reserve
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_max_payload
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_exit_thread
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol xdr_encode_opaque
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_proc_register
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol cache_purge
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol nfsd_debug
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol qword_add
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol cache_unregister
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_set_num_threads
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_process
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol unix_domain_find
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol rpcauth_lookup_credcache
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol qword_addhex
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol qword_get
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_create_pooled
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol xdr_init_decode
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol auth_unix_forget_old
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol sunrpc_cache_lookup
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_sock_names
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol rpc_create
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_destroy
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svcauth_unix_purge
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol rpc_call_sync
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol auth_unix_add_addr
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol cache_check
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_makesock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_set_client
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol rpciod_up
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol xdr_reserve_space
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol rpciod_down
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol cache_register
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_seq_show
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol cache_flush
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_proc_unregister
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol put_rpccred
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_addsock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol svc_print_addr
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol auth_unix_lookup
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol rpc_call_async
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol xdr_init_encode
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol sunrpc_cache_update
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfsd/nfsd.ko needs unknown symbol auth_domain_put
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs_common/nfs_acl.ko needs unknown symbol xdr_decode_array2
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs_common/nfs_acl.ko needs unknown symbol xdr_encode_word
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs_common/nfs_acl.ko needs unknown symbol xdr_encode_array2
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs_common/nfs_acl.ko needs unknown symbol xdr_decode_word
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_put_task
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_new_task
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_proc_register
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_wake_up_task
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_write_pages
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_shutdown_client
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol svc_recv
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_inline_decode
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_mkpipe
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_wake_up
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol svc_exit_thread
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_encode_opaque
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_read_pages
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_encode_opaque_fixed
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_sleep_on
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_run_task
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_init_task
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_print_iostats
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_enter_page
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_encode_pages
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol __rpc_wait_for_completion_task
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_setbufsize
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_clnt_sigmask
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_clone_client
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol svc_process
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_init_decode
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_max_payload
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_proc_unregister
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_exit_task
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_bind_new_program
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_create
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol svc_destroy
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol svc_create
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_call_sync
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_queue_upcall
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_delay
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol svc_makesock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol svc_create_thread
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_execute
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpciod_up
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_reserve_space
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_clnt_sigunmask
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpcauth_lookupcred
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpciod_down
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_restart_call
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_inline_pages
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_call_setup
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_init_wait_queue
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol put_rpccred
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_unlink
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol svc_print_addr
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpc_call_async
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol rpcauth_create
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_init_encode
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol nfs_debug
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/nfs/nfs.ko needs unknown symbol xdr_shift_buf
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol svc_wake_up
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol xdr_decode_string_inplace
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol svc_recv
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol rpc_peeraddr
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol svc_exit_thread
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol xdr_encode_netobj
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol svc_process
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol nlm_debug
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol rpc_create
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol svc_destroy
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol svc_create
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol rpc_call_sync
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol rpc_delay
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol svc_makesock
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol svc_create_thread
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol svc_set_client
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol rpciod_up
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol rpciod_down
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol rpc_force_rebind
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol rpc_restart_call
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol xdr_encode_string
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol xdr_decode_netobj
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol svc_print_addr
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol rpc_call_async
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/fs/lockd/lockd.ko needs unknown symbol rpc_destroy_client
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_free_hw
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_alloc_hw
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_register_hw
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_wake_queue
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_tx_status_irqsafe
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_ctstoself_get
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_start_queues
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_stop_queue
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_stop_queues
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_get_hdrlen
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_unregister_hw
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_rts_get
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_register_hwmode
WARNING: /lib/modules/2.6.21-rc5-mm3/kernel/drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko needs unknown symbol ieee80211_rx_irqsafe
