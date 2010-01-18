Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177Ab0ARWRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0ARWRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 17:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253Ab0ARWRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 17:17:53 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:38869 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0ARWRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 17:17:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YFl8o45a5zEMYNUXghHg9kDWQArQ3uhB64lQnhWHo97okHQwbuyF1m6KvyLfIj8Dyt
         DH8mADDAM6h/MX39plJr3WADces8CcpiUaE4CpxlUpBUGAtgQYtHXFQIxabB8X/A22SN
         i4jq6RqbbqKMRZqEbgasxt6K/qWxmB7zIUQus=
Date: Mon, 18 Jan 2010 23:17:47 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100118221747.GH3157@del.dom.local>
References: <4B53906B.2020608@majjas.com>
 <20100117230531.GC3161@del.dom.local>
 <4B539A0A.2000504@majjas.com>
 <20100118073018.GA6270@ff.dom.local>
 <4B548C6B.10607@majjas.com>
 <20100118204658.GC3157@del.dom.local>
 <4B54CB0D.5070604@majjas.com>
 <20100118212516.GE3157@del.dom.local>
 <4B54D50C.90608@majjas.com>
 <20100118220814.GG3157@del.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118220814.GG3157@del.dom.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 11:08:14PM +0100, Jarek Poplawski wrote:
> Btw, I wonder if you could test it skipping the (HP?) switch?

If so, then of course don't forget to try tcpdump on the router.

Jarek P.
