Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0CCStx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:49:53 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60687 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab0CCStv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:49:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lYpEPd+Pyhl4AMm8kNrWjtAysMQSouBOdUy593/3jJf6G7EHD5lSuMPFTWnm6Xkgzs
         bzX7YCNr2BKIG4g5DtVTHXCSUI69mlI88pUxIReINuJCvjArFmdExsZGzLFnXwjSttPA
         JfQ72T1TAKPbTwynKiwMG+9TVG/WtgSys6HdU=
Message-ID: <4B8EADE5.5010109@pobox.com>
Date: Wed, 03 Mar 2010 13:43:49 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] ahci: Move generic code into libahci
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru> <20100303171747.GI12362@oksana.dev.rtsoft.ru>
In-Reply-To: <20100303171747.GI12362@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 12:17 PM, Anton Vorontsov wrote:
> This patch should contain no functional changes, just moves code
> around.

Excellent!  I like how this patch series is split up.  You've precisely 
what you needed to do here -- major code movement should avoid any 
changes outside the minimum required to build this patch.

Others should follow your example :)


> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> new file mode 100644
> index 0000000..3ec32ee
> --- /dev/null
> +++ b/drivers/ata/libahci.c
> @@ -0,0 +1,2059 @@
> +/*
> + *  ahci.c - AHCI SATA low-level routines

this should reflect new filename



> diff --git a/drivers/ata/libahci.h b/drivers/ata/libahci.h
> new file mode 100644
> index 0000000..60bce4e
> --- /dev/null
> +++ b/drivers/ata/libahci.h
> @@ -0,0 +1,330 @@
> +/*
> + *  ahci.c - AHCI SATA low-level routines

Ditto.

Note that my preference for header file name would be ahci.h rather than 
libahci.h, to reflect that it includes generic AHCI hardware definitions 
as well as libahci structures and function prototypes.

