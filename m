Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZHMUC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZHMUC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZHMUCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:02:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755928AbZHMUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:02:47 -0400
Date: Thu, 13 Aug 2009 12:59:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 27/28] ALSA: hda - Add missing vmaster initialization
 for ALC269
In-Reply-To: <20090813194339.809516126@mini.kroah.org>
Message-ID: <alpine.LFD.2.01.0908131258420.28882@localhost.localdomain>
References: <20090813194021.446758568@mini.kroah.org> <20090813194339.809516126@mini.kroah.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Aug 2009, Greg KH wrote:
> 
> From: Takashi Iwai <tiwai@suse.de>
> 
> commit 100d5eb36ba20dc0b99a17ea2b9800c567bfc3d1 upstream.
> 
> Without the initialization of vmaster NID, the dB information got
> confused for ALC269 codec.
> 
> Reference: Novell bnc#527361
> 	https://bugzilla.novell.com/show_bug.cgi?id=527361
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  sound/pci/hda/patch_realtek.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -13767,6 +13767,8 @@ static int patch_alc861vd(struct hda_cod
>  
>  	spec->vmaster_nid = 0x02;
>  
> +	spec->vmaster_nid = 0x02;
> +
>  	codec->patch_ops = alc_patch_ops;

You seem to have already applied this one earlier ;)

		Linus
