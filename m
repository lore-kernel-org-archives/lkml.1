Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbZHJGyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbZHJGyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZHJGyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:54:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:2019 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbZHJGyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=tncPWjge2o5MQBwflVejlR31LvP4F7ROJz9Ott0KMgcPqLtn/uVSG0W6D228YmwbQQ
         5WuTz65dIlyKCAgr0YgXt05CeEkf6RdlzmYiN+8yToBzI3gbTeGGfKEPd1rJ/MJkL69b
         /97oNoSrRV46YRFNMxA5k5kC066/s8wM/cZl0=
Date: Sun, 9 Aug 2009 23:54:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, eric.y.miao@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, openezx-devel@lists.openezx.org,
       Ilya Petrov <ilya.muromec@gmail.com>,
       Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH v3] input: PCAP2 misc input driver
References: <1249678456-15381-1-git-send-email-drwyrm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249678456-15381-1-git-send-email-drwyrm@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090810072431.D2068526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:54:16PM +0200, Daniel Ribeiro wrote:
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 0d979fd..679bae3 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -26,3 +26,4 @@ obj-$(CONFIG_INPUT_TWL4030_PWRBUTTON)	+= twl4030-pwrbutton.o
>  obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
>  obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
>  obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
> +obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o

Btw, could we please keep Makefile sorted alphabetically? This should
help with merge conflicts a bit (I know Kconfig is still not sorted).

-- 
Dmitry
