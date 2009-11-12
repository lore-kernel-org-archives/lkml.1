Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZKLVGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZKLVGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZKLVGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:06:45 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:39741 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbZKLVGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:06:39 -0500
Date: Thu, 12 Nov 2009 21:06:31 +0000
From: Martin Michlmayr <tbm@cyrius.com>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: akpm@linux-foundation.org, hpa@zytor.com, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] Add support for LZO-compressed kernels for ARM
Message-ID: <20091112210631.GA29311@deprecation.cyrius.com>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-3-git-send-email-albin.tonnerre@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257942478-18719-3-git-send-email-albin.tonnerre@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Albin Tonnerre <albin.tonnerre@free-electrons.com> [2009-11-11 13:27]:
> This is the second part of patch. This part includes:
>  - changes to ach/arch/boot/Makefile to make it easier to add new
>    compression types
>  - changes in arch/arm/boot/compressed/misc.c to allow the use of lzo or
>    gzip, depending on the config

I tested your arm patch together with your unsubmitted patch to allow
lzma and it works great!  Thanks a lot for working on this.  Feel free
to add my:

Tested-by: Martin Michlmayr <tbm@cyrius.com>

I tested lzma compressed kernels on the following ARM machines:
 - Linksys NSLU2 (ixp4xx)
 - SheevaPlug (kirkwood)
 - QNAP TS-219 (kirkwood)
 - Thecus N2100 (iop32x)

-- 
Martin Michlmayr
http://www.cyrius.com/
