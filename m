Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbXGKKty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbXGKKty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760044AbXGKKtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:49:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:50133 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597AbXGKKto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:49:44 -0400
Date: Tue, 10 Jul 2007 14:52:56 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [POWERPC] mmio ide support for mpc8349-itx target
Message-ID: <20070710145256.6ac64e11@localhost.localdomain>
In-Reply-To: <468FC376.2040405@ru.mvista.com>
References: <20070707094852.9473.21013.stgit@localhost.localdomain>
	<20070707094900.9473.48577.stgit@localhost.localdomain>
	<468FC376.2040405@ru.mvista.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jul 2007 20:46:46 +0400
Sergei Shtylyov wrote:

> > +
> > +#ifdef CONFIG_MPC834x_ITX  
> 
>     Erm, isn't this stuff misplaced? Is this really SoC device? I
> remember seeng this in the arch/ppc/ platform code before (in the
> internal tree)...

The point is to declare methods bsp, as mmio access may effectively vary (having bugs or intentionally) from platform to platform. All-in-one driver approach is nice but might be an issue to handle/maintain.

Thanks for looking at it, other notes make sense.

-- 
Sincerely, Vitaly
