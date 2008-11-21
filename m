Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbYKUTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbYKUTVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYKUTVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:21:05 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:10543 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYKUTVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:21:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=mZOyl+Cyxa6G+R0b92Hq2pGhj1uNJIu4eB9yrubyBhfmNKClzY8l8Ks79NGehvR1aF
         RvkHdrgOD7kbtKD7oPHyG8RsyY9m+5Lq+Cy6Q4fJiJufhrbgR3Pz9erwv89MFY39nd2w
         os3KgkFR5AHBFUAm+7T8ZW46r7xNPUAknYvm8=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] report
Date: Sat, 22 Nov 2008 03:20:38 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <49270a1b.02066e0a.0854.5215@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following is a list of all functions whose argument comments 
may be insufficient.

It has cover all files in net/*.

-----------
The summary for count-less:
24:  */ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq, struct sk_buff *skb)
in: ../../linux-2.6/net/dccp/options.c

7:  */ int cipso_v4_skbuff_setattr(struct sk_buff *skb, const struct cipso_v4_doi *doi_def, const struct netlbl_lsm_secattr *secattr)
in: ../../linux-2.6/net/ipv4/cipso_ipv4.c

3:  */ static void ip6_tnl_link(struct ip6_tnl_net *ip6n, struct ip6_tnl *t)
in: ../../linux-2.6/net/ipv6/ip6_tunnel.c

19:  */ int llc_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt, struct net_device *orig_dev)
in: ../../linux-2.6/net/llc/llc_input.c

14:  */ static int llc_ui_create(struct net *net, struct socket *sock, int protocol)
in: ../../linux-2.6/net/llc/af_llc.c

16:  */ static int llc_ui_sendmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg, size_t len)
in: ../../linux-2.6/net/llc/af_llc.c

10:  */ static int recv_stream(struct kiocb *iocb, struct socket *sock, struct msghdr *m, size_t buf_len, int flags)
in: ../../linux-2.6/net/tipc/socket.c

13:  */ static void llc_sap_mcast(struct llc_sap *sap, const struct llc_addr *laddr, struct sk_buff *skb)
in: ../../linux-2.6/net/llc/llc_sap.c

9:  */ static int recv_msg(struct kiocb *iocb, struct socket *sock, struct msghdr *m, size_t buf_len, int flags)
in: ../../linux-2.6/net/tipc/socket.c

18:  */ struct sock *llc_sk_alloc(struct net *net, int family, gfp_t priority, struct proto *prot)
in: ../../linux-2.6/net/llc/llc_conn.c

26:  */ u32 dccp_sample_rtt(struct sock *sk, long delta)
in: ../../linux-2.6/net/dccp/input.c

8:  */ static void udp4_hwcsum_outgoing(struct sock *sk, struct sk_buff *skb, __be32 src, __be32 dst, int len )
in: ../../linux-2.6/net/ipv4/udp.c

21:  */ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock, struct sockaddr_rxrpc *srx, struct key *key, unsigned long user_call_ID, gfp_t gfp)
in: ../../linux-2.6/net/rxrpc/af_rxrpc.c

25:  */ static void ccid3_hc_tx_update_x(struct sock *sk, ktime_t *stamp)
in: ../../linux-2.6/net/dccp/ccids/ccid3.c

17:  */ int llc_conn_remove_acked_pdus(struct sock *sk, u8 nr, u16 *how_many_unacked)
in: ../../linux-2.6/net/llc/llc_conn.c

20:  */ int iucv_message_send2way(struct iucv_path *path, struct iucv_message *msg, u8 flags, u32 srccls, void *buffer, size_t size, void *answer, size_t asize, size_t *residual)
in: ../../linux-2.6/net/iucv/iucv.c

15:  */ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg, size_t len, int flags)
in: ../../linux-2.6/net/llc/af_llc.c

1:  */ static struct ip6_tnl * ip6_tnl_lookup(struct net *net, struct in6_addr *remote, struct in6_addr *local)
in: ../../linux-2.6/net/ipv6/ip6_tunnel.c

4:  */ static struct ip6_tnl *ip6_tnl_locate(struct net *net, struct ip6_tnl_parm *p, int create)
in: ../../linux-2.6/net/ipv6/ip6_tunnel.c

6:  */ void rtnl_unregister_all(int protocol)
in: ../../linux-2.6/net/core/rtnetlink.c

2:  */ static struct ip6_tnl ** ip6_tnl_bucket(struct ip6_tnl_net *ip6n, struct ip6_tnl_parm *p)
in: ../../linux-2.6/net/ipv6/ip6_tunnel.c

12:  */ static void llc_sap_rcv(struct llc_sap *sap, struct sk_buff *skb, struct sock *sk)
in: ../../linux-2.6/net/llc/llc_sap.c

5:  */ static __u16 parse_tlv_tnl_enc_lim(struct sk_buff *skb, __u8 * raw)
in: ../../linux-2.6/net/ipv6/ip6_tunnel.c

22:  */ int mesh_path_error_tx(u8 *dst, __le32 dst_dsn, u8 *ra, struct ieee80211_sub_if_data *sdata)
in: ../../linux-2.6/net/mac80211/mesh_hwmp.c

23:  */ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr, struct ieee80211_sub_if_data *sdata)
in: ../../linux-2.6/net/mac80211/mesh.c

11:  */ struct sk_buff *llc_alloc_frame(struct sock *sk, struct net_device *dev, u8 type, u32 data_size)
in: ../../linux-2.6/net/llc/llc_sap.c

