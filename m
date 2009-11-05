Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZKENrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZKENrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbZKENrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:47:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:43663 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413AbZKENrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:47:20 -0500
Subject: Re: [PATCH 4/8] powerpc/qe&cpm: Implement static inline stubs for non-QE/CPM builds
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20091012164920.GD4578@oksana.dev.rtsoft.ru>
Date: Thu, 5 Nov 2009 07:46:48 -0600
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F65088B7-CBE6-4CD5-8715-E3C504C99A6E@kernel.crashing.org>
References: <20091012164841.GA32214@oksana.dev.rtsoft.ru> <20091012164920.GD4578@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2009, at 11:49 AM, Anton Vorontsov wrote:

> This is needed to avoid ugly #ifdefs in drivers. Also update  
> fsl_qe_udc
> driver so that now it doesn't define its own versions that cause build
> breakage when the generic stubs are used.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
> arch/powerpc/include/asm/cpm.h  |   44 ++++++++++++++++++++++++++++++ 
> +++++++++
> arch/powerpc/include/asm/qe.h   |   11 ++++++++-
> drivers/usb/gadget/fsl_qe_udc.h |   15 -------------
> 3 files changed, 54 insertions(+), 16 deletions(-)

applied to next

- k
