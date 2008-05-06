Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbYEFJYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbYEFJYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764391AbYEFJPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:15:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:24027 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764257AbYEFJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vrMAXUqncIWiONehfO51TuSbEXPabRSdF0aFlB0BpKhGBHOQfTHfFjs7RyuaPHnynrUytugd34w27nuXB8X8Gx/xiL2co+mZZJU97nrqZNm1tl2XTo+bvPC9Ucnc5MP7bx3u6Z8Jl6Oy/rRkLVKl4WSJaZidBgNm4Eo2vNyDP2k=
Message-ID: <c4e36d110805060215s689c5163rad17df8838310bc3@mail.gmail.com>
Date: Tue, 6 May 2008 11:15:07 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: Suspend to memory is freezing my machine
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080505141034.GD5351@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
	 <20080505141034.GD5351@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/5 Pavel Machek <pavel@suse.cz>:
> Hi!
>
>
>  > Also - I think that option no_console_suspend doens't work correctly -
>  > as many times with suspend I do not see any log message on my console
>  > screen. However sometimes the log is shown.
>
>  Try switching consoles with alt-arrows... s2ram plays with console
>  switches so messages may be there but on other console.
>                                                                         Pavel

No change - logging is simply not visible anywhere - if there will be some time
I could probably bisect and find which commit randomised console logging.

Zdenek
