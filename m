Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbYFGLQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbYFGLQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 07:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbYFGLQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 07:16:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36255 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbYFGLQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 07:16:39 -0400
Date: Sat, 7 Jun 2008 13:17:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make clean: remove *.o.* as well
Message-ID: <20080607111720.GA25693@uranus.ravnborg.org>
References: <20080606214709.GA8680@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606214709.GA8680@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 01:47:09AM +0400, Alexey Dobriyan wrote:
> Those are left presumably from aborted ccache(1) compilations:
> 
> 	arch/x86/kernel/.tmp_io_apic_64.o.T5veul
> 	arch/x86/kvm/.tmp_x86.o.SZWn69
> 	arch/x86/mm/.tmp_pgtable.o.sL1LTf
> 	drivers/ieee1394/.tmp_ieee1394_transactions.o.bUj6o1
> 	drivers/infiniband/hw/mlx4/.tmp_main.o.vy0ep6
> 
> BTW, with git there is nice way to check for such nuisainces:
> 
> 	make mrproper
> 	git-ls-files -o
> 
> should give empty output.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Thanks, applied.

	Sam
