Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYF1Fts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYF1Fts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 01:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYF1Ftj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 01:49:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:14909 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYF1Fth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 01:49:37 -0400
Message-ID: <fa686aa40806272249l7eae0c34k43a20ad41672b77a@mail.gmail.com>
Date: Fri, 27 Jun 2008 22:49:36 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: monstr@seznam.cz
Subject: Re: [PATCH 12/60] microblaze_v4: Generic dts file for platforms
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, "Michal Simek" <monstr@monstr.eu>
In-Reply-To: <1214483429-32360-13-git-send-email-monstr@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
X-Google-Sender-Auth: 5db678cb3158068a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 5:29 AM,  <monstr@seznam.cz> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/platform/generic/system.dts |  300 +++++++++++++++++++++++++++
>  1 files changed, 300 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/platform/generic/system.dts

Since this is a generated file, and entirely bitstream specific, does
it make sense to include it in the kernel tree?  If it does, then is
it produced from one of the Xilinx reference designs?  Can you add
documentation to the header that specifies exactly which design
version this .dts is for?

>
> diff --git a/arch/microblaze/platform/generic/system.dts b/arch/microblaze/platform/generic/system.dts
> new file mode 100644
> index 0000000..724a037
> --- /dev/null
> +++ b/arch/microblaze/platform/generic/system.dts
> @@ -0,0 +1,300 @@
> +/*
> + * (C) Copyright 2007-2008 Xilinx, Inc.
> + * (C) Copyright 2007-2008 Michal Simek
> + *
> + * Michal SIMEK <monstr@monstr.eu>

If this is a generated file, then is this copyright notice even appropriate?

> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> + * MA 02111-1307 USA

I don't this whole large legal block is necessary.  Unless specified
otherwise in the comment block, I believe GPL licencing is pretty much
assumed and so the above three copyrights should be redundant.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
