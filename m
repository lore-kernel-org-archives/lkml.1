Return-Path: <linux-kernel-owner+w=401wt.eu-S1765559AbZEAWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765559AbZEAWdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765073AbZEAWdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:33:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41922
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759063AbZEAWdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:33:07 -0400
Date: Fri, 01 May 2009 15:33:01 -0700 (PDT)
Message-Id: <20090501.153301.42015656.davem@davemloft.net>
To: alex.williamson@hp.com
Cc: rusty@rustcorp.com.au, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] virtio_net: Cleanup command queue scatterlist usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090427154925.4771.63651.stgit@debian.lart>
References: <20090426.233014.216353908.davem@davemloft.net>
	<20090427154925.4771.63651.stgit@debian.lart>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Williamson <alex.williamson@hp.com>
Date: Mon, 27 Apr 2009 09:50:03 -0600

> We were avoiding calling sg_init* on scatterlists passed
> into virtnet_send_command to prevent extraneous end markers.
> This caused build warnings for uninitialized variables.
> Cleanup the code to create proper scatterlists.
> 
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>

This patch does not apply even to Linus's current tree.
