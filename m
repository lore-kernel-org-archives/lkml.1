Return-Path: <linux-kernel-owner+w=401wt.eu-S932399AbZEAWnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbZEAWnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZEAWnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:43:21 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40322 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZEAWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:43:20 -0400
Subject: Re: [PATCH] virtio_net: Cleanup command queue scatterlist usage
From: Alex Williamson <alex.williamson@hp.com>
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-next@vger.kernel.org
In-Reply-To: <20090501.153301.42015656.davem@davemloft.net>
References: <20090426.233014.216353908.davem@davemloft.net>
	 <20090427154925.4771.63651.stgit@debian.lart>
	 <20090501.153301.42015656.davem@davemloft.net>
Content-Type: text/plain
Organization: HP OSLO R&D
Date: Fri, 01 May 2009 16:43:14 -0600
Message-Id: <1241217794.9646.588.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 15:33 -0700, David Miller wrote:
> From: Alex Williamson <alex.williamson@hp.com>
> Date: Mon, 27 Apr 2009 09:50:03 -0600
> 
> > We were avoiding calling sg_init* on scatterlists passed
> > into virtnet_send_command to prevent extraneous end markers.
> > This caused build warnings for uninitialized variables.
> > Cleanup the code to create proper scatterlists.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@hp.com>
> 
> This patch does not apply even to Linus's current tree.

It was against net-next-2.6.git, I'll update it for linux-2.6.git.
IIRC, it applied with some fuzz.

Alex

