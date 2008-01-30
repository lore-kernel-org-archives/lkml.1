Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYA3G1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYA3G1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 01:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYA3G1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 01:27:34 -0500
Received: from mail.vyatta.com ([216.93.170.194]:40170 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbYA3G1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 01:27:34 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.995
Date: Tue, 29 Jan 2008 22:27:29 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "PV Juliet" <pvjuliet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Change In sk_buff structure in 2.6.22 kernel
Message-ID: <20080129222729.1f4fef95@deepthought>
In-Reply-To: <fd0955ee0801292119l1859a04aic07b23c59c5359a@mail.gmail.com>
References: <fd0955ee0801292119l1859a04aic07b23c59c5359a@mail.gmail.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 10:49:49 +0530
"PV Juliet" <pvjuliet@gmail.com> wrote:

> Hi All,
> 
> 
> The header fields in the sk_buff structure have been renamed and are
> no longer unions.
> 
> Networking code and drivers are supposed to use skb->transport_header,
> skb->network_header, and skb->skb_mac_header.
> But when I am trying to access fields of TCP using the code
> struct tcphdr *tcp = skb->transport_header;
> tcp->   //accessing proper field
> It is not accessing the value properly ...
> Can anyone please help me ???
> 
> 
> Thanks in advance
> Regards
> Juliet

Read the source (include/linux/skbuff.h)

Use the new accessor functions skb_transport_header(skb), skb_network_header(skb),


-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
