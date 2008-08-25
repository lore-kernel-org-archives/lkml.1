Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYHYVOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYHYVOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYHYVNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:13:45 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:54391 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbYHYVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:13:44 -0400
X-Auth-Info: 8Hz83UcD/3V+jW/mQvPNkndSbQTG+uzJi3GbFK75zCk=
X-Auth-Info: 8Hz83UcD/3V+jW/mQvPNkndSbQTG+uzJi3GbFK75zCk=
X-Auth-Info: 8Hz83UcD/3V+jW/mQvPNkndSbQTG+uzJi3GbFK75zCk=
X-Auth-Info: 8Hz83UcD/3V+jW/mQvPNkndSbQTG+uzJi3GbFK75zCk=
X-Auth-Info: 8Hz83UcD/3V+jW/mQvPNkndSbQTG+uzJi3GbFK75zCk=
To: Remy Bohmer <linux@bohmer.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       u-boot@lists.denx.de, sam@ravnborg.org, Stefan Roese <sr@denx.de>
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [U-Boot] [patch 1/2] Enable the use of an uncompressed kernel image for U-boot uImage
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <48b309fe.0a04d00a.527b.ffffa801@mx.google.com>
References: <20080825191427.728251800@bohmer.net>> <48b309fe.0a04d00a.527b.ffffa801@mx.google.com>
Comments: In-reply-to Remy Bohmer <linux@bohmer.net>
   message dated "Mon, 25 Aug 2008 21:14:28 +0200."
Date: Mon, 25 Aug 2008 23:13:42 +0200
Message-Id: <20080825211342.8FE7024899@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Remy,

In message <48b309fe.0a04d00a.527b.ffffa801@mx.google.com> you wrote:
> Normally the 'zImage' is used as base for uImage.
> Enable the capability to use the raw uncompressed 'Image' instead

This is an interesting feature, but...

> +config UNCOMPRESSED_UIMAGE
> +	bool "Use uncompressed kernel image for uImage"

.. I think it is wrong to make this a configuration option. Instead, a
separate make target should be used so you can actually chose which
image you wantr (or even both versions) without having to reconfigure
/ rebuild the kernel.


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
GUIs  are  virtually  useless.  Learn  tools.  They're  configurable,
scriptable, automatable, cron-able, interoperable, etc. We don't need
no brain-dead winslurping monolithic claptrap.
                               -- Tom Christiansen in 371140df@csnews
