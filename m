Return-Path: <linux-kernel-owner+w=401wt.eu-S933228AbXGLQ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbXGLQ2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbXGLQ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:28:29 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4228 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758536AbXGLQ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:28:29 -0400
Date: Thu, 12 Jul 2007 18:28:39 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Rob Landley <rob@landley.net>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Start to genericize kconfig for use by other projects.
In-Reply-To: <200707111522.14240.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0707121820110.1817@scrub.home>
References: <200707111522.14240.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 11 Jul 2007, Rob Landley wrote:

> Replace name "Linux Kernel" in menuconfig with a macro (defaulting to "Linux
> Kernel" if not -Ddefined by the makefile), and remove a few unnecessary
> occurrences of "kernel" in pop-up text.

Could you drop the PROJECT_NAME changes for now? The rest looks fine.
I would prefer if the project would be settable via Kconfig.
If you want to play with it add this to Kconfig:

config PROJECT_NAME
	string
	default "Linux kernel"

and at the end of conf_parse() you can lookup, calculate and cache the 
value.

bye, Roman
