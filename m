Return-Path: <linux-kernel-owner+w=401wt.eu-S965371AbXIGLto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965371AbXIGLto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 07:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965193AbXIGLti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 07:49:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42338 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965189AbXIGLth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 07:49:37 -0400
Date: Fri, 7 Sep 2007 13:49:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bill Nottingham <notting@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add CONFIG_VT_UNICODE
In-Reply-To: <20070831201820.GF31970@nostromo.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0709071348090.25942@fbirervta.pbzchgretzou.qr>
References: <20070831201820.GF31970@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 31 2007 16:18, Bill Nottingham wrote:
>
>As of now, the kernel defaults to non-unicode and XLATE for the keyboard.
>We've been changing this in Fedora, but that requires patching the defaults
>in the kernel.
>
>The attached introduces CONFIG_VT_UNICODE, which sets the console in unicode
>mode by default on boot, including both the virtual terminal and the keyboard
>driver.

I would prefer to:
 - make default_utf=1 in the source
 - add "default_utf8 ? VC_UNICODE : VC_XLATE" to the keyboard code
   as your patch does
 - and do away with the new CONFIG_ option, since, surprise, surprise,
   you can change it at runtime, so there is no need to do it
   at compile-time too.


	Jan
-- 
