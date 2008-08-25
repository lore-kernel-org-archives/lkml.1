Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYHYVS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYHYVS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbYHYVSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:18:42 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51683 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbYHYVSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:18:41 -0400
X-Auth-Info: r/ArKe+mewJxP9jz1UUulynyKOlgavWgwVaQWngxagQ=
X-Auth-Info: r/ArKe+mewJxP9jz1UUulynyKOlgavWgwVaQWngxagQ=
X-Auth-Info: r/ArKe+mewJxP9jz1UUulynyKOlgavWgwVaQWngxagQ=
X-Auth-Info: r/ArKe+mewJxP9jz1UUulynyKOlgavWgwVaQWngxagQ=
X-Auth-Info: r/ArKe+mewJxP9jz1UUulynyKOlgavWgwVaQWngxagQ=
To: Remy Bohmer <linux@bohmer.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       u-boot@lists.denx.de, sam@ravnborg.org, Stefan Roese <sr@denx.de>
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [U-Boot] [patch 2/2] Add support for building the new U-boot uImage format (FIT-format)
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <48b30a00.1701d00a.4ee8.ffffa5f7@mx.google.com>
References: <20080825191427.728251800@bohmer.net>> <48b30a00.1701d00a.4ee8.ffffa5f7@mx.google.com>
Comments: In-reply-to Remy Bohmer <linux@bohmer.net>
   message dated "Mon, 25 Aug 2008 21:14:29 +0200."
Date: Mon, 25 Aug 2008 23:18:39 +0200
Message-Id: <20080825211839.CF83524899@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Remy,

In message <48b30a00.1701d00a.4ee8.ffffa5f7@mx.google.com> you wrote:
> Allow building of the newer FIT-image format for U-boot, while keeping
> it possible to build the legacy format, for people who do not want to (or can) 
> upgrade to U-boot 1.3.3 or newer.
> 
> If an older mkimage is detected, or if there is no dtc (Device Tree Compiler)

Why should there ever be no dtc? It is part of the Linux kernel source
tree, see arch/powerpc/boot/dtc-src

> then automagically the legacy format is created.
> There is also a possibility to force the legacy format by means of a Kconfig
> option.

As before, I think this should not be implemented as a  configuration
option; it should be selectable as separate make targets without need
to reconfigure / rebuild the kernel.

> Note: This patch only adapts this for ARM, AVR32, Blackfin and sh architectures.
>       It does not adapt the PowerPC tree, because PowerPC does not use the
>       script at scripts/mkuboot.sh

Hm... Power support would be especially interesting, of course :-)

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Without facts, the decision cannot be made logically. You  must  rely
on your human intuition.
	-- Spock, "Assignment: Earth", stardate unknown
