Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765Ab0ADStz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0ADStz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674Ab0ADStv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:49:51 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:34298 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0ADStu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:49:50 -0500
Date: Mon, 4 Jan 2010 18:49:48 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] drivers/net/defxx.c: use %pM to show MAC address
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F63E@mi8nycmail19.Mi8.com>
Message-ID: <alpine.LFD.2.00.1001041833560.13474@eddie.linux-mips.org>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F63E@mi8nycmail19.Mi8.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009, H Hartley Sweeten wrote:

> Use the %pM kernel extension to display the MAC address.
> 
> The only difference in the output is that the MAC address is
> shown in the usual colon-separated hex notation.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David S. Miller <davem@davemloft.net>

 Nack.  While I appreciate your effort, the FDDI standard defines opposite 
bit-ordering for MAC addresses written in the dash-separated and the 
colon-separated hexadecimal notation, which makes your change invalid, 
sorry (you'd have to bit-swap them too and that would make addresses 
counter-intuitive).  Please note that `ifconfig' consistently uses the 
dash-separated notation for FDDI interfaces too (I haven't checked other 
tools like those in the "iproute" package; they may be buggy).

 [I'd appreciate to be CCed on patch submissions to code I claim 
maintenance of too.]

  Maciej
