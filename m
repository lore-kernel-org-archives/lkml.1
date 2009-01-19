Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZASOQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZASOQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZASOOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:14:16 -0500
Received: from mail-gx0-f25.google.com ([209.85.217.25]:49984 "EHLO
	mail-gx0-f25.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZASOON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:14:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IE8fvwCTUqS/dql6buDa6NH72witAtB1uXxAL3sMrV/Se947RLGAczZpiRSymjEIsR
         PBCH+EQWwRI3+12lsdH/Cy5CzCGcarTjQ+hPBCRDC2NHLbEDysFl+T7Kg093ZsixA5nl
         BSDPjHANF7gPtLE9IXZPlXoBxDk1s8ju/wTJc=
Date: Mon, 19 Jan 2009 22:13:46 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: xming <xmingske@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: wrong sym link with out-of-tree build with 2.6.28
Message-ID: <20090119141346.GA8258@hack.private>
References: <519a8b110901190604l4c248ea2n88a117a064c35fac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519a8b110901190604l4c248ea2n88a117a064c35fac@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 03:04:54PM +0100, xming wrote:
>Hi,
>
>I am building kernels on x86 and there is a problems with include2/asm
>symbolic link
>when building the with 'make O=./HOST".
>
>- with 2.6.28.x the include/asm-x86 is moved to arch/x86/include/asm
>  so this code is no more valid:
>  ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;
>
>That line of code should be made ARCH aware? I don't know how to do that, I can
>only change that for x86 only.
>
>BTW: I am not subscribed to lkml, please CC when replying, thanks

Please have a look at this thread:

http://lkml.org/lkml/2008/8/15/166

I think Sam explained there. Thanks.


-- 
"Against stupidity, the gods themselves, contend in vain."

