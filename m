Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbXIWGRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbXIWGRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 02:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbXIWGRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 02:17:07 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46605 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbXIWGRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 02:17:07 -0400
Date: Sun, 23 Sep 2007 08:17:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unfortunate infinite make recursion
In-Reply-To: <20070922205216.GB31873@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0709230815580.15712@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709221319440.15712@fbirervta.pbzchgretzou.qr>
 <20070922205216.GB31873@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 22 2007 22:52, Sam Ravnborg wrote:
>
>Does the following patch fix it at your end?
>Seems to work for me.

Yes.

>-
>+# Check the OUTPUT directory is not the same as where we have kernel src
>+$(if $(filter-out $(KBUILD_OUTPUT),$(shell /bin/pwd)),, \
>+     $(error Output directory (O=...) specify kernel src dir))

Should be "specifies".

> PHONY += $(MAKECMDGOALS)
> 
> $(filter-out _all,$(MAKECMDGOALS)) _all:
>

