Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZH1Fqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZH1Fqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 01:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbZH1Fqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 01:46:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:45460 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZH1Fqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 01:46:51 -0400
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Message-Id: <04A4E77E-C7A2-46B7-8AF4-966868E3AEDA@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20090818220418.GD25090@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 4/8] powerpc/qe&cpm: Implement static inline stubs for non-QE/CPM builds
Date: Fri, 28 Aug 2009 00:45:56 -0500
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru> <20090818220418.GD25090@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 18, 2009, at 5:04 PM, Anton Vorontsov wrote:

> This is needed to avoid ugly #ifdefs in drivers. Also update  
> fsl_qe_udc
> driver so that now it doesn't define its own versions that cause build
> breakage when the generic stubs are used.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> arch/powerpc/include/asm/cpm.h  |   44 ++++++++++++++++++++++++++++++ 
> +++++++++
> arch/powerpc/include/asm/qe.h   |   11 ++++++++-
> drivers/usb/gadget/fsl_qe_udc.h |   15 -------------
> 3 files changed, 54 insertions(+), 16 deletions(-)


applied to next

- k
