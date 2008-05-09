Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYEISzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYEISzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYEISzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:55:31 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:14778 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759963AbYEISz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CBupT+HeSMWVgKiZTx/S3JDiF4w/Db8qDM8GwZRyqYrwu60KMTrvsyHljiVxYAnrNXWYk9p74U7vNOjJBxjNJcFAkv6nWlo+VAzqRBbuH28+KyQrN3s+mJyMFkyGDkaDPxoyinxrJTL1X/VbZU1YRbQXcSUUVvLb2klEME3A5tU=
Message-ID: <e9c3a7c20805091155w741fc8eai761fa232bb27dedf@mail.gmail.com>
Date: Fri, 9 May 2008 11:55:25 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Sebastian Siewior" <lkml@ml.breakpoint.cc>
Subject: Re: [PATCH] [ASYNC_TX] don't include <asm/> headers
Cc: "Maciej Sosnowski" <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080509083912.GA32396@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426154801.GA18712@Chamillionaire.breakpoint.cc>
	 <e9c3a7c20804292342o38ca485by4dec2d137fefcac5@mail.gmail.com>
	 <20080509083912.GA32396@Chamillionaire.breakpoint.cc>
X-Google-Sender-Auth: c22bb762702a82b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2008 at 1:39 AM, Sebastian Siewior <lkml@ml.breakpoint.cc> wrote:
> * Dan Williams | 2008-04-29 23:42:46 [-0700]:
>
>
>  >Thanks, I'll push this out for testing in -next / -mm.
>  I can't see this in current -next and I can't remember that I got an
>  email from Andrew.
>

Hi Sebastian,

Yes I had put this in the background for awhile due to other issues.
I fixed up a few merge conflicts so that it will apply against the
current tree; however, the patch causes these new warnings:

include/asm/xor_32.h:513: warning: 'xor_block_pII_mmx' defined but not used
include/asm/xor_32.h:521: warning: 'xor_block_p5_mmx' defined but not used
include/asm/xor_32.h:853: warning: 'xor_block_pIII_sse' defined but not used
include/asm-generic/xor.h:680: warning: 'xor_block_8regs' defined but not used
include/asm-generic/xor.h:688: warning: 'xor_block_32regs' defined but not used
include/asm-generic/xor.h:696: warning: 'xor_block_8regs_p' defined but not used
include/asm-generic/xor.h:704: warning: 'xor_block_32regs_p' defined
but not used

It is not immediately clear why?

--
Dan
