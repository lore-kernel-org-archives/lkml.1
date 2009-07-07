Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZGGH7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZGGH7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZGGH7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:59:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZGGH7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:59:41 -0400
Date: Tue, 7 Jul 2009 09:59:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SOUND: Remove commented out usage of dead
 MODULE_PARM().
In-Reply-To: <alpine.LFD.2.00.0907042040540.10980@localhost>
Message-ID: <alpine.LNX.2.00.0907070959190.4994@wotan.suse.de>
References: <alpine.LFD.2.00.0907042040540.10980@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jul 2009, Robert P. J. Day wrote:

> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>   get rid of that commented usage of the now defunct MODULE_PARM macro
> simply because it pollutes a scan for actual references to that dead
> macro.
> 
> diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
> index 1edab7b..3136c88 100644
> --- a/sound/oss/swarm_cs4297a.c
> +++ b/sound/oss/swarm_cs4297a.c
> @@ -110,9 +110,6 @@ static void start_adc(struct cs4297a_state *s);
>  // rather than 64k as some of the games work more responsively.
>  // log base 2( buff sz = 32k).
> 
> -//static unsigned long defaultorder = 3;
> -//MODULE_PARM(defaultorder, "i");
> -
>  //
>  // Turn on/off debugging compilation by commenting out "#define CSDEBUG"
>  //

Oh what a horrible driver anyway ...

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
