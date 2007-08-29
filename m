Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbXH2RAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbXH2RAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXH2RAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:00:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:30198 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbXH2RAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:00:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Rcs8PYuWXMdAFOykJqs+n3hC64zj9WYHiRBTixniDTKmL4h4nwqQkSv0qTL5/FuYkJSRbRZh+pAJFT/fiLHBV/K9l4F2JrkUWTKYAUvB3mTFMeBGHQNhSYeT9IbTDRdecBv3fKW/dzKwdYaz8gNQYS9WN7xW5QoNs+Ju9sBr/LI=
Message-ID: <31e679430708291000n64a4e97aq5e326678a1fe9827@mail.gmail.com>
Date: Wed, 29 Aug 2007 13:00:34 -0400
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Bret Towe" <magnade@gmail.com>
Subject: Re: linux-2.6.23-rc4 ppc build failure
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <dda83e780708290941g1685879bned63a77d6b0fd242@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780708290941g1685879bned63a77d6b0fd242@mail.gmail.com>
X-Google-Sender-Auth: 7da428285b58e252
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 8/29/07, Bret Towe <magnade@gmail.com> wrote:
> while trying to build a fresh kernel for my mini after upgrading from gutsy
> (and forgetting to save my .config) I hit the below build error

The .config you can get from /boot/config-`uname -r`

> 2.6.23-rc3 I did work under feisty but that is with a different .config
> so not sure if that makes any difference or not
> I've not bisected cause it takes so long on this computer...
> attached is the config I'm working off now
>
> arch/powerpc/platforms/built-in.o: In function `pmac_probe':
> setup.c:(.init.text+0xbba): undefined reference to `pmac_ide_get_base'
> setup.c:(.init.text+0xbbe): undefined reference to `pmac_ide_init_hwif_ports'
> setup.c:(.init.text+0xbc6): undefined reference to `pmac_ide_get_base'
> setup.c:(.init.text+0xbca): undefined reference to `pmac_ide_init_hwif_ports'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make[1]: Leaving directory `/usr/src/linux-2.6'
>
>


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
