Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZEEEYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZEEEYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 00:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZEEEYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 00:24:30 -0400
Received: from ozlabs.org ([203.10.76.45]:53972 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbZEEEY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 00:24:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alex Williamson <alex.williamson@hp.com>
Subject: Re: [PATCH] virtio_net: Cleanup command queue scatterlist usage
Date: Tue, 5 May 2009 12:51:52 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: davem@davemloft.net, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-next@vger.kernel.org
References: <20090426.233014.216353908.davem@davemloft.net> <20090427154925.4771.63651.stgit@debian.lart>
In-Reply-To: <20090427154925.4771.63651.stgit@debian.lart>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051251.53271.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 01:20:03 am Alex Williamson wrote:
> We were avoiding calling sg_init* on scatterlists passed
> into virtnet_send_command to prevent extraneous end markers.
> This caused build warnings for uninitialized variables.
> Cleanup the code to create proper scatterlists.
> 
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
