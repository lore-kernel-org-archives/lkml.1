Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZKLXEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZKLXEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbZKLXEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:04:35 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:58495 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbZKLXEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:04:34 -0500
Date: Thu, 12 Nov 2009 13:16:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bernhard Kaindl <bernhard.kaindl@gmx.net>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] Support loading and saving custom remarks for
	config symbols
Message-ID: <20091112121648.GE1394@ucw.cz>
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org> <b106dec1237ab723ae6a2404d42601bf20704bf3.1256767265.git.aragorn@Anduril.ringwar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b106dec1237ab723ae6a2404d42601bf20704bf3.1256767265.git.aragorn@Anduril.ringwar.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This code supports one-line remarks without newlines. The changes to
> the tools (menuconfig, xconfig, config) also only support one-line
> remarks as they use the existing UI functions for editing strings.
> 
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index 797a741..eee2b60 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -152,6 +152,30 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
>  	return 0;
>  }
>  
> +/**
> + * Read remarks from -remarks file:
> + */

/** means kerneldoc but this is not valid kerneldoc.


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
