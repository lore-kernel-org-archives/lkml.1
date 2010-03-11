Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab0CKU0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:26:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56692 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab0CKU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:26:42 -0500
Date: Thu, 11 Mar 2010 20:26:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>, rajeev-dlh.kumar@st.com,
       shiraz.hashim@st.com, armando.visconti@st.com,
       ashish.priyadarshi@st.com, linux-kernel@vger.kernel.org,
       vipin.kumar@st.com, amit.goel@st.com, deepak.sikri@st.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 10/11] ST SPEAr: Added default configuration files for
	SPEAr machines
Message-ID: <20100311202603.GD25011@n2100.arm.linux.org.uk>
References: <1267592861-26911-3-git-send-email-viresh.kumar@st.com> <1267592861-26911-4-git-send-email-viresh.kumar@st.com> <1267592861-26911-5-git-send-email-viresh.kumar@st.com> <1267592861-26911-6-git-send-email-viresh.kumar@st.com> <1267592861-26911-7-git-send-email-viresh.kumar@st.com> <1267592861-26911-8-git-send-email-viresh.kumar@st.com> <1267592861-26911-9-git-send-email-viresh.kumar@st.com> <1267592861-26911-10-git-send-email-viresh.kumar@st.com> <1267592861-26911-11-git-send-email-viresh.kumar@st.com> <63386a3d1003111218g5799974cv3336ceaa2b3367a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d1003111218g5799974cv3336ceaa2b3367a9@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 09:18:40PM +0100, Linus Walleij wrote:
> 2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:
> > (...)
> > +CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> 
> Not specifically related to this defconfig because hundreds of defconfigs
> use this, but HAVE_GENERIC_DMA_COHERENT is not used in anything but
> a few Kconfig files, all just defining it. No single Makefile, #ifdef
> or anything
> else seems to be using this, so what is it for?? I can't find any use even if I
> go back to kernel 2.6.11 on LXR.

Err...

drivers/base/Makefile:obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o

include/asm-generic/dma-coherent.h:#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT

