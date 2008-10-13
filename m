Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbYJMSo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbYJMSo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYJMSot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:44:49 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:44280 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYJMSot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:44:49 -0400
Date: Mon, 13 Oct 2008 13:44:43 -0500
From: Scott Wood <scottwood@freescale.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: enable heap randomization for linkstations
Message-ID: <20081013184443.GA20612@ld0162-tx32.am.freescale.net>
References: <20081013040703.GA11059@ime.usp.br> <20081013045116.GA11637@ime.usp.br> <Pine.LNX.4.64.0810132003350.9041@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0810132003350.9041@axis700.grange>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 08:05:09PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 13 Oct 2008, Rogério Brito wrote:
> 
> > The current defconfig for Linkstation/Kuroboxes has the "Disable Heap
> > Randomization" option enabled.
> > 
> > Since some of these machines are facing the internet, it helps to have
> > heap randomization enabled. This patch enables it.
> 
> Same as the previous patch - this is one of options, that users select 
> according to their needs. If any specific distribution enables this option 
> by default in their kernels, they can do this too, don't think this is 
> critical enough to patch the defconfig.

Just because users/distros can change it doesn't mean it's pointless to
discuss what default is sane, and make changes if the current default
isn't.

For security-related options it's usually best to default to the more
secure state, especially since the option description talks about it
being needed mainly for libc5 compatibility -- did libc5 ever even exist
for powerpc?  

The only reason it was turned on in the first place was likely the
"default y", which in turn is there to avoid breaking old x86 distros.

-Scott
