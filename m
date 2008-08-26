Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYHZKcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYHZKcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbYHZKcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:32:00 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:30566 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbYHZKb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xHBsbw0i7yresL5H3TZG8le8N8WkIv5+zUSFfxpA9xp9mIlF0iDKE4011jqpp94qf8
         5Hste49PJJv5cP6UwnI9k3ZxCDA6FOBazSxQPKhbMmT9D7vxkcRjjM8CGgqtKJ3O/jHw
         3YQqbeq5c3Vf8IPtD43t+/PgbNZGu/Tr5XqOI=
Message-ID: <3efb10970808260331v634536fduc06e3456b078bc8a@mail.gmail.com>
Date: Tue, 26 Aug 2008 12:31:57 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Wolfgang Denk" <wd@denx.de>
Subject: Re: [U-Boot] [patch 2/2] Add support for building the new U-boot uImage format (FIT-format)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       u-boot@lists.denx.de, sam@ravnborg.org, "Stefan Roese" <sr@denx.de>
In-Reply-To: <20080825211839.CF83524899@gemini.denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080825191427.728251800@bohmer.net>
	 <48b30a00.1701d00a.4ee8.ffffa5f7@mx.google.com>
	 <20080825211839.CF83524899@gemini.denx.de>
X-Google-Sender-Auth: de1e68ca0690a12e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfgang,

>> If an older mkimage is detected, or if there is no dtc (Device Tree Compiler)
> Why should there ever be no dtc? It is part of the Linux kernel source
> tree, see arch/powerpc/boot/dtc-src

uuh, because it was not there in 2.6.24...?
And that was the kernel I made the patch for originally...

Will look into (all) your comments.
Thanks,

Remy


>
>> then automagically the legacy format is created.
>> There is also a possibility to force the legacy format by means of a Kconfig
>> option.
>
> As before, I think this should not be implemented as a  configuration
> option; it should be selectable as separate make targets without need
> to reconfigure / rebuild the kernel.
>
>> Note: This patch only adapts this for ARM, AVR32, Blackfin and sh architectures.
>>       It does not adapt the PowerPC tree, because PowerPC does not use the
>>       script at scripts/mkuboot.sh
>
> Hm... Power support would be especially interesting, of course :-)
>
> Best regards,
>
> Wolfgang Denk
>
> --
> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
> Without facts, the decision cannot be made logically. You  must  rely
> on your human intuition.
>        -- Spock, "Assignment: Earth", stardate unknown
>
