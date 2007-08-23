Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbXHWFvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbXHWFvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 01:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXHWFux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 01:50:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51928 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbXHWFuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 01:50:52 -0400
Date: Thu, 23 Aug 2007 11:33:43 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, perex@suse.cz,
       liam.girdwood@wolfsonmicro.com, trivial@kernel.org
Subject: Re: [Git Patch] sound/isa/wavefront/wavefront_synth.c: Remove a lot
 of unnecessary stuffs
In-Reply-To: <20070822071422.GA8215@hacking>
Message-ID: <alpine.LFD.0.999.0708231125120.2049@enigma.security.iitk.ac.in>
References: <20070822071422.GA8215@hacking>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Aug 2007, WANG Cong wrote:
> 
> Remove unnecessary white spaces, tabs, white lines, wrap lines, parenthesises,
> braces, semicolons etc.

:-)

The file clearly had a lot of codingstyle problems, but so does your
patch, sadly.

> @@ -134,8 +134,8 @@ MODULE_PARM_DESC(osrun_time, "how many s
>  #define STAT_CAN_WRITE		0x20
>  #define STAT_INTR_WRITE		0x40
>  
> -static int wavefront_delete_sample (snd_wavefront_t *, int sampnum);
> -static int wavefront_find_free_sample (snd_wavefront_t *);
> +static int wavefront_delete_sample(snd_wavefront_t *, int sampnum);
                                                       ^
> +static int wavefront_find_free_sample(snd_wavefront_t *);
                                                          ^
IMHO you should specify identifiers for the arg-list of a function
prototype even though they aren't technically required. The kernel
favours that style overwhelmingly for good reason -- helps identify
_what_ that argument is with just one look at the prototype.


> @@ -229,14 +229,12 @@ static struct wavefront_command wavefron
>  
>  static const char *
>  wavefront_errorstr (int errnum)
                     ^

Whitespace should go ... ditto in zillion other places in this file.

Also, you could combine the above two lines into a single line -- that's
the general style followed by most of the kernel, and I've noticed tools
such as cscope / ctags getting confused otherwise (though this is really
a bug in those tools). That'll further reduce LOC, allowing more code to
be displayed per-screenful, which is always good.
