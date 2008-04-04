Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbYDDPMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbYDDPMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbYDDPMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:12:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:30997 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYDDPM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iwMkJUwEh6tn0PqbROF2sPPunT9ZqLYihLa79TKQeDl6bIUvOkR2V5w/Vn4mw8d3GMhxYXPyrUqTP+tBFCeWDEuXtIKWbH/nwD4PGgwi5uWax+IdxsazTNzfWITKoGvZLYoAqRPHBs1FmgejDuWwlp7hm11Z73fgPdrIq3bpevE=
Message-ID: <dd18b0c30804040812x76f99af7o99fa57c9a1ec10bc@mail.gmail.com>
Date: Fri, 4 Apr 2008 15:12:27 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: 2.6.25 intended change: smc:kbd_backlight vs. smc::kbd_backlight ?
Cc: rpurdie@rpsys.net, "Julien BLACHE" <jb@jblache.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1207292068.4511.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1207162690.9669.11.camel@localhost>
	 <1207292068.4511.10.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I noticed this as well, you loose the greatest feature; the
cool leds lights on the keyboard with the macbook pro,
A solution that worked for me was to compile pommed from the source
and edit kbd_backlight.h
regards;
               Justin P. Mattock

On Fri, Apr 4, 2008 at 6:54 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> On Wed, 2008-04-02 at 20:58 +0200, Soeren Sonnenburg wrote:
>  > Dear all,
>  >
>  > I am wondering whether the change from
>  >
>  > /sys/devices/platform/applesmc.768/leds/smc:kbd_backlight  (2.6.24)
>  > /sys/devices/platform/applesmc.768/leds/smc::kbd_backlight (2.6.25)
>  >
>  > is intentional?
>  >
>  > I recognized that it breaks current userspace applications changing the
>  > keyboard background leds like pommed...
>
>  OK it looks like commit 6c152beefbf90579d21afc4f7e075b1f801f9a75 from
>  Richard Purdie, 'leds: Standardise LED naming scheme' introduced this
>  change.
>
>  Why do we need '::' instead of a single ':' (that would not have broken
>  things)?
>
>  Also sometimes only a single ':' seperator is used like in
>  corgi:green:mail but e.g. not in clevo::mail ?!
>
>  Soeren
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Justin P. Mattock
