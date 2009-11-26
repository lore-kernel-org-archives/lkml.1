Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbZKZRrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbZKZRrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZKZRrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:47:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZKZRrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:47:14 -0500
Date: Thu, 26 Nov 2009 09:47:15 -0800
From: Greg KH <gregkh@suse.de>
To: ??ric Piel <E.A.B.Piel@tudelft.nl>
Cc: Alan Cox <alan@linux.intel.com>, mchehab@redhat.com,
       linux-kernel@vger.kernel.org, Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH] Edwin T??r??k found the following, so fix it
Message-ID: <20091126174715.GA8592@suse.de>
References: <20091126152154.18281.24788.stgit@localhost.localdomain> <4B0EB0CB.9050006@tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0EB0CB.9050006@tudelft.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 05:46:03PM +0100, ??ric Piel wrote:
> Op 26-11-09 16:22, Alan Cox schreef:
> > In function ???memset???,
> > inlined from ???ir_input_init??? at drivers/media/common/ir-functions.c:67:
> > /home/edwin/builds/linux-2.6/arch/x86/include/asm/string_64.h:61:
> > warning: call to ???__warn_memset_zero_len??? declared with attribute
> > warning: memset used with constant zero length parameter; this could be
> > due to transposed parameters
> > memset(ir->ir_codes, sizeof(ir->ir_codes), 0);
> Hello,
> A "grep -E "memset.*,.*, 0\\)" -r" also reports
> drivers/staging/hv/StorVsc.c as a suspect:
> memset(request, sizeof(struct storvsc_request_extension), 0);
> memset(vstorPacket, sizeof(struct vstor_packet), 0);
> memset(vstorPacket, sizeof(struct vstor_packet), 0);
> memset(vstorPacket, sizeof(struct vstor_packet), 0);
> 
> Maybe someone cares about fixing it too?

It's already fixed in linux-next and will be sent to Linus soon.

thanks,

greg k-h
