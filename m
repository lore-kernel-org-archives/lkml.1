Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbZEKXhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbZEKXhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbZEKXg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:36:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58013
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942AbZEKXg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:36:56 -0400
Date: Mon, 11 May 2009 16:36:52 -0700 (PDT)
Message-Id: <20090511.163652.156749735.davem@davemloft.net>
To: Luc.Goria@adept-telecom.fr
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, alan@redhat.com
Subject: Re: [PATCH 2.6.27.2] datagram handling routines :
 mapping/unmapping paged data in soft IRQ
From: David Miller <davem@davemloft.net>
In-Reply-To: <54466B0E862D654998371DCA86B6FE2F4B6D47@adept-srv2.adept.local>
References: <54466B0E862D654998371DCA86B6FE2F4B6D47@adept-srv2.adept.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luc Goria" <Luc.Goria@adept-telecom.fr>
Date: Mon, 11 May 2009 15:32:21 +0200

> 
> Kernel crashes when a network module tries to copy a datagram to iovec in soft IRQ with paged data.
> The problem is that kunmap function can't be called in IRQ.
> All calls to kmap/kunmap fonctions are replaced by calls to kmap_skb_frag/kunmap_skb_frag when paged data are involved.
> 
>  <<datagram.c.patch>> 
> Signed-off-by: Luc GORIA <luc.goria@adept-telecom.fr>

What network module does this?  You're not supposed to.

