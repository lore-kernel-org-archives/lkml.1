Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab0CNMoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 08:44:46 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37433 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab0CNMon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 08:44:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:reply-to:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=T25QFNK+XIHIBhhjdwq71ONlxG/4HSg7Id6YWGobHfzZz3ntlHz0E6khk9r3IKb8RG
         h5UbZl5noUddMc2ig92T2SECeHuIqbP/gqb5UpBxdeIddVtBTJame2rInDwRk7DanE6d
         FuNpoGRvjurI+bmuO+o33fbYWGyGJyBiZBpnU=
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] RDC321x southbridge and GPIO support
Date: Sun, 14 Mar 2010 13:44:31 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-686; KDE/4.3.4; i686; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>, Wim Van Sebroeck <wim@iguana.be>,
       Ingo Molnar <mingo@elte.hu>
References: <201003110942.03602.florian@openwrt.org>
In-Reply-To: <201003110942.03602.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003141344.34139.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel,

Any comments on this? Thanks.

Le jeudi 11 mars 2010 09:42:03, Florian Fainelli a écrit :
> Hi Wim, Samuel, Ingo,
> 
> Here are 4 patches relative to adding support for the RDC321x southbridge.
> This southbridge is present on all x86-based RDC321x System-on-a-Chip and
> provides access to GPIOs and Wathchdog. The watchdog driver is already
>  merged.
> 
> Samuel, this is rebased on top of your mfd-2.6 master branch after commit
> 522dba7 and I think the 4 patches should go via your tree to make sure the
> merge is consistent.
> 
> Thank you.
> 
> Florian Fainelli (4):
>   x86: remove rdc321x_defs.h
>   MFD: add support for the RDC321x southbridge
>   GPIO: add support for RDC321x GPIO controller
>   WATCHDOG: convert rdc321x_wdt to use southbridge accessors
> 

