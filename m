Return-Path: <linux-kernel-owner+w=401wt.eu-S1764970AbYBTWSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764970AbYBTWSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbYBTWSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:18:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:40392 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764715AbYBTWST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:18:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ErbageNirjUNdFD18GwjMYn+D5BsHnGgjWQGMJuhRcXgh+YRcDWR62yP7qDXSnBGGkzjSRk8c0TNjMbBnpo6kfq8NdGsSsFDqkjCd0vcTDbPoStvRwdRAZyKkE2IUK4o2vntlDIyPaHoMemOdUpFQHDy2eQ2wmkRgzJY5nSuX68=
Subject: Re: sparse - make __CHECK_ENDIAN__ default enabled?
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080220220326.GA22328@uranus.ravnborg.org>
References: <20080220220326.GA22328@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 14:18:33 -0800
Message-Id: <1203545913.25307.47.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-20 at 23:03 +0100, Sam Ravnborg wrote:
> Hi Harvey.
> 
> Can I ask you to look into the worst offenders so we
> can make -D__CHECK_ENDIAN__ enabled per default
> in the kernel.
> Or maybe we should do it anyway?

Well, I've got the worst of fs and drivers/ata done so far, still
weeping over the 5500 warnings in drivers. (X86_32 allyesconfig).
People ignore the existing warnings anyway, why not toss a few more
on the pile?

I'll look them over tonight and see how bad it would be.


> I made a quick test-run with a x86 64 bit defconfig.
> My first thought was that this was just really bad
> because the amount of warnings roughly doubled.
> 
> But then inspecting it a little closer I could see
> that 8 files had an increase of > 100 additional
> warnings when we enabled __CHECK_ENDIAN__ and
> that smells like easy targets to bring down the noise.
> 
> I did not dare do it for an allyesconfig run - I 
> am not that brave.

Well, I'm just going through the _trivial_ ones first to try and cut
the noise down a bit.  I think with all the patches I have out there
I've cut a little over 1000 lines off an allyesconfig build on X86_32
so far.


Harvey

