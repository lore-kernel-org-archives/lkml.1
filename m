Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYK0OLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYK0OLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYK0OLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:11:16 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:24140 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbYK0OLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:11:15 -0500
Message-ID: <fa686aa40811270611j58ceb6e5lffc37fc3f83d00e7@mail.gmail.com>
Date: Thu, 27 Nov 2008 07:11:13 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Yuri Tikhonov" <yur@emcraft.com>
Subject: Re: [PATCH][v2] xsysace: use resource_size_t instead of unsigned long
Cc: linux-kernel@vger.kernel.org, "Wolfgang Denk" <wd@denx.de>,
       "Detlev Zundel" <dzu@denx.de>, "Ilya Yanok" <yanok@emcraft.com>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <200811271521.27642.yur@emcraft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811271521.27642.yur@emcraft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 5:21 AM, Yuri Tikhonov <yur@emcraft.com> wrote:
> Use resource_size_t for physical address of SystemACE
> chip. This fixes the driver brokeness for 32 bit systems
> with 64 bit resources (e.g. PPC440SPe).

Hey Yuri,

I actually already picked up the last version of your patch after
fixing it up myself.  It's currently sitting in Paul's powerpc tree
and it will be merged into mainline when Linus gets back from
vacation.

Can you please spin a new version with just the addition of the
compatible value and base it on Paul's tree.

Thanks,
g.
