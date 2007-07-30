Return-Path: <linux-kernel-owner+w=401wt.eu-S967370AbXG3Sy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967370AbXG3Sy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763331AbXG3Syu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:54:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:48202 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965966AbXG3Syt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=RRG5gkvGkxgEfVncdWcGS2r5Do0aLb4mXlsugLDfhgYLwmGrVXNT/sLNEH0xpoTHnwsVteNCmbx0bqVuXCoNNOGgNazpRdgcfm6NQW6KqXMCljsg33cH5mmvRCDBm2wFo0B8v7kBopyfj6nEV+PxIbdy6P+ftW55E0SBC+vwzi4=
Date: Mon, 30 Jul 2007 22:54:45 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Remove fs.h from mm.h
Message-ID: <20070730185445.GA5776@martell.zuzino.mipt.ru>
References: <20070729223613.GA5916@martell.zuzino.mipt.ru> <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 05:08:20PM -0700, Linus Torvalds wrote:
> On Mon, 30 Jul 2007, Alexey Dobriyan wrote:
> > 
> > Cross-compile tested without regressions on my two usual configs and (sigh):
> > 
> > alpha              arm-mx1ads        mips-bigsur          powerpc-ebony
> ..
> 
> Heh. 
> 
> Kudos for going above and beyond.
> 
> 	"But where is blackfin and frv?"

Actually frv was tested (and patched), just not glued to cross-build
setup, so I forgot to mention it. As for blackfin, ehh, umm, toolchain
issues...

