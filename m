Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab0CMIvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 03:51:46 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57702 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab0CMIvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 03:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dlReh6ggWz3HyZ1MNSMHY3BGgdyqZILqZm0dWIYfUXH5wxi0sKjWrU21yWkVFHBJcR
         au0Wi8PStVQMoQ9KvfKwPe4LzX65z3OTyeRHTaL+wxOlThRLUPokfC1WmE/I6C2x2xoo
         4r82lxYCWtU0gcQPODZtrE0uLpXIeInFxXzKc=
Message-ID: <4B9B51B1.8010904@gmail.com>
Date: Sat, 13 Mar 2010 09:49:53 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Yuasa Yoichi <yuasa@linux-mips.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
References: <4B968834.3040609@gmail.com> <21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com> <2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com> <21eaeb5a1003100120x6cd3f69ak598954af3c9fe955@mail.gmail.com> <2ea1731b1003100415i46dd8fcem85b85f49fb1a479@mail.gmail.com> <20100312144854.cb94d9b4.akpm@linux-foundation.org> <20100312233144.GG6491@shareable.org>
In-Reply-To: <20100312233144.GG6491@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/03/2010 00:31, Jamie Lokier ha scritto:
> That'd be fine if the kernel link scripts choose the address, as long
> as it's consistent between different compiles and similar
> configurations.  That'd be a bit simpler than the admin having to know
> the memory map well enough to choose an address.
> 
> -- Jamie
> 

I agree, but the bootloader should be aware of it. I mean, usually
bootloaders at boot, reset the RAM, so you have to tell to the
bootloader that you are using a piece of RAM as persistent RAM, for
example U-Boot has got a specific option CONFIG_PRAM. I don't know if
all the process can be completely transparent to the admin in all
situations.

Marco
