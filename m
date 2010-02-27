Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967964Ab0B0IMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:12:53 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35235 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967911Ab0B0IMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:12:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TIKdt1W+R4RKTLoLIRmgeXtGDK2g25dxDnjZbGVnCkqREn82ScoBM+wr27J8v+nojx
         JxInQOu48XMggEt3mCt1304BCr25Gpp+oCEulqx0j8OfeLxYYaIu9YkTfFG+IKyGDwGX
         cIs35XGLG1kAx7YovLFI4G11LV7RES3MRCMXc=
Date: Sat, 27 Feb 2010 00:12:48 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] hp-wmi: Add support for tablet rotation key
Message-ID: <20100227081248.GG793@core.coreip.homeip.net>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
 <1267197527-18062-14-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267197527-18062-14-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 10:18:46AM -0500, Matthew Garrett wrote:
> The HP touchsmart tablet has a key for rotating the UI from landscape to
> portrait. Add support for it.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/platform/x86/hp-wmi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
> index ad4c414..3aa57da 100644
> --- a/drivers/platform/x86/hp-wmi.c
> +++ b/drivers/platform/x86/hp-wmi.c
> @@ -89,6 +89,7 @@ static struct key_entry hp_wmi_keymap[] = {
>  	{KE_KEY, 0x20e6, KEY_PROG1},
>  	{KE_KEY, 0x2142, KEY_MEDIA},
>  	{KE_KEY, 0x213b, KEY_INFO},
> +	{KE_KEY, 0x2169, KEY_DIRECTION},

I'd appreciate a patch for input.h commenting on intended use of
KEY_DIRECTION.

Thanks.

-- 
Dmitry
