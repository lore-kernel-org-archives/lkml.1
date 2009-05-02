Return-Path: <linux-kernel-owner+w=401wt.eu-S1751201AbZEBE1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbZEBE1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 00:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbZEBE04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 00:26:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46095
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbZEBE0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 00:26:55 -0400
Date: Fri, 01 May 2009 21:26:50 -0700 (PDT)
Message-Id: <20090501.212650.211196891.davem@davemloft.net>
To: alex.williamson@hp.com
Cc: rusty@rustcorp.com.au, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] virtio_net: Cleanup command queue scatterlist usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090502032646.7927.99584.stgit@debian.lart>
References: <20090501.153301.42015656.davem@davemloft.net>
	<20090502032646.7927.99584.stgit@debian.lart>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Williamson <alex.williamson@hp.com>
Date: Fri, 01 May 2009 21:27:56 -0600

> We were avoiding calling sg_init* on scatterlists passed
> into virtnet_send_command to prevent extraneous end markers.
> This caused build warnings for uninitialized variables.
> Cleanup the code to create proper scatterlists.
> 
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>

Applied.
