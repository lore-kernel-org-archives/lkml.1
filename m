Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbZCXLAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbZCXLAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758496AbZCXLAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:00:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55295 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101AbZCXLAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k3z/5Ql3M7bmyAc00JytXQUkVNeb1lxx+BZG0FfgatTaGzlNw5BGxrHejpV8GTvgr4
         sIxLqhUmEDApeRnYFbx4MQZcyHrhCwlnos2R9yLGZ+/Npj084iZdV/9iga3A1zGeglWt
         SFKP9WYJmTMLH8H0wTe5KecPhxNma0856jMF4=
MIME-Version: 1.0
In-Reply-To: <OF4CC8EBC2.BDA9C1A9-ON48257583.0014767E-48257583.0014EE2B@sunnorth.com.cn>
References: <OF4CC8EBC2.BDA9C1A9-ON48257583.0014767E-48257583.0014EE2B@sunnorth.com.cn>
Date: Tue, 24 Mar 2009 11:00:05 +0000
Message-ID: <87a5b0800903240400n43c1f0eak15875d8d29a60525@mail.gmail.com>
Subject: Re: [PATCH] score - New architecure port to SunplusCT S+CORE 
	processor
From: Will Newton <will.newton@gmail.com>
To: liqin@sunnorth.com.cn
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 3:46 AM,  <liqin@sunnorth.com.cn> wrote:
> Hello, Linus and folks,
>
> We have ported Linux to the S+CORE processor, which is a 32-bit RISC
> embedded
> microprocessor of Sunplus Core Technology.
>
> SPG29X, SPG300(score core) processor have been used in game products.
> and score toolchain have commit to gnu in 2006. We have a team to maintain
> score code for linux kernel.
>
> We would like to release a patch for kernel 2.6.29-rc8.
> This patch include score header files, arch files and serial driver for
> spct6600(score core) platform.
>
> For the other driver patches, I'll send them one by one in
> small size latter. Thanks!
>
> Would you merge them to the stock kernel?
>
> Patch information is slightly bigger, so I placed it on our SunplusCT web
> site.
> http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch
>
> Signed off by: Chen Liqin <liqin.chen@sunplusct.com,
> liqin@sunnorth.com.cn>

To allow people to more easily review your patches it is recommended
to spit them up into smaller pieces and submit them to the mailing
list.

Your port looks relatively clean but it looks like it is borrowing
heavily from the mips port and you may have a few leftovers from that
e.g.:

- mentions of o32 (unless S+CORE has an o32 ABI?)
- compatibility syscalls, sys_ipc, old-style signal handling. Are
these really needed for a new arch?
- does SCORE+ have ll/sc instructions or is that another leftover from MIPS?
- does your port support SMP?
