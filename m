Return-Path: <linux-kernel-owner+w=401wt.eu-S1751439AbZG3IhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbZG3IhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbZG3IhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:37:19 -0400
Received: from web15703.mail.cnb.yahoo.com ([202.165.102.70]:45364 "HELO
	web15703.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751109AbZG3IhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:37:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=eu/lyy130KZ2udxRkmDnRy8Ivtlq8mOOteocWtu9h2nedk/za7+NVT6lYy54VUKfzwujE6pzSQgLSBSNgbY/MC2ORPyp7t/TSmeJhqGkGAK0zgM+iayUcQEQtR3Uvy9wkpDjVRPfikRktu/s2SiSVpSL5R3qMTPEMMqzHNL0Ykg=;
Message-ID: <434589.51834.qm@web15703.mail.cnb.yahoo.com>
X-YMail-OSG: 38tPbtMVM1nLHUiwqLuYoifrC.77AA.4OdG5USnvb4E.2sdYu_jj5WzVdPDbH9MqPvbgeUfQswzK.Lmth4YEb2k0Qe24IAgY_6qJ2a.bN6H3XpSj2OwVYpXO4lr1wQQuHY6A687eIUGAS8KX02ZwHL7Wn__NelWxUrOnV.CpFZ._wyc-
X-Mailer: YahooMailClassic/6.0.19 YahooMailWebService/0.7.289.15
Date: Thu, 30 Jul 2009 16:37:16 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Subject: Ask a question about kfree_skbmem and disassemble 
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

I'm not be familiar with assemble .
I want to know how to explain follow .

80195170:       00808021        move    s0,a0
80195174:       3c028029        lui     v0,0x8029
80195178:       8c44db90        lw      a0,-9328(v0)
8019517c:       02002821        move    a1,s0

------source code and it's assemble---------------
void kfree_skbmem(struct sk_buff *skb)
{
	skb_release_data(skb);
	kmem_cache_free(skbuff_head_cache, skb);
}


80195160 <kfree_skbmem>:
80195160:       27bdffe8        addiu   sp,sp,-24
80195164:       afbf0014        sw      ra,20(sp)
80195168:       afb00010        sw      s0,16(sp)
8019516c:       0c0654bd        jal     801952f4 <skb_release_data>
80195170:       00808021        move    s0,a0
80195174:       3c028029        lui     v0,0x8029
80195178:       8c44db90        lw      a0,-9328(v0)
8019517c:       02002821        move    a1,s0
80195180:       8fbf0014        lw      ra,20(sp)
80195184:       8fb00010        lw      s0,16(sp)
80195188:       0802c86a        j       800b21a8 <kmem_cache_free>
8019518c:       27bd0018        addiu   sp,sp,24
------------------------------------------------------


Thanks a lot 
Best Regards.
Peter Meng


      
