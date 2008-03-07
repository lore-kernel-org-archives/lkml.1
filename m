Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbYCGViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbYCGViT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761273AbYCGVh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:37:59 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:42465 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761216AbYCGVh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:37:58 -0500
Subject: Re: [PATCH] drivers/pcmcia/soc_common.c: convert
	soc_pcmcia_sockets_lock in a mutex
From: Daniel Walker <dwalker@mvista.com>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: linux-pcmcia@lists.infradead.org, nico@cam.org, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080307183742.GF2783@traven>
References: <20080307183742.GF2783@traven>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 13:37:55 -0800
Message-Id: <1204925875.10627.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-07 at 19:37 +0100, Matthias Kaehlcke wrote:
>  extern struct list_head soc_pcmcia_sockets;
> -extern struct semaphore soc_pcmcia_sockets_lock;
> +extern struct mutex soc_pcmcia_sockets_lock;

If it's extern'ed I wonder where else it's getting used? If it's not
used anyplace else, may as werll remove the extern and make it static ..

Daniel

