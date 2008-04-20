Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbYDTAxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbYDTAxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 20:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYDTAw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 20:52:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60980
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbYDTAw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 20:52:58 -0400
Date: Sat, 19 Apr 2008 17:52:59 -0700 (PDT)
Message-Id: <20080419.175259.204074091.davem@davemloft.net>
To: kaber@trash.net
Cc: clem@clem.clem-digital.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: 2.6.25-git2 fails build (nf_nat_proto_sctp.ko)
From: David Miller <davem@davemloft.net>
In-Reply-To: <480A278E.60507@trash.net>
References: <200804191329.m3JDTS0m023459@clem.clem-digital.net>
	<480A278E.60507@trash.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Sat, 19 Apr 2008 19:10:38 +0200

> Pete Clements wrote:
> > Root device is (3, 1)
> > Setup is 11288 bytes (padded to 11776 bytes).
> > System is 1162 kB
> > CRC 695701be
> > Kernel: arch/x86/boot/bzImage is ready  (#4)
> >   Building modules, stage 2.
> >   MODPOST 132 modules
> > ERROR: "crc32c_le" [net/ipv4/netfilter/nf_nat_proto_sctp.ko] undefined!
> 
> 
> Sorry about that. We need to select LIBCRC32C.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, t hanks Patrick.
