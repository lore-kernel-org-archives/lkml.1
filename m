Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZJRIYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZJRIYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZJRIYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:24:50 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37100 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZJRIYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:24:46 -0400
X-Greylist: delayed 1642 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Oct 2009 04:24:46 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hSs0v3WpOOwdN2wjDJq78+vVdyUClZNICRThu9ETgBkmh0Zc1psn+5T6mpiqUnoinI
         kxTrNmgNnire5G4+vVldQd5K53N1MlBa54fOEV4Xr1K4dafFgIHuFzw5y7LE3uTg2inh
         nwpjkAgUeRs/vSFQSr2yD7VuVnRczHzZX+05o=
Date: Sun, 18 Oct 2009 00:57:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor-oss@comcast.net>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch][rfc] depend pcspkr on CONFIG_EMBEDDED
Message-ID: <20091018075723.GI3935@core.coreip.homeip.net>
References: <4ADA3593.4010607@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADA3593.4010607@aknet.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stas,

On Sun, Oct 18, 2009 at 01:22:27AM +0400, Stas Sergeev wrote:
> Hello.
>
> As most of the problems with snd-pcsp
> are now settled and the major distros
> are starting to unblacklist it and use
> instead of pcspkr:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=539767
> I'd like to do that sneaky thing.
> The major argument for keeping pcspkr
> I've heard, was that it doesn't require
> the entire ALSA stack, and in this
> case I think it is usefull only with
> CONFIG_EMBEDDED. Right now it is a common
> situation when the both modules are
> built, and whichever gets loaded first,
> works.
> So can something like the attached
> patch be applied?

I think it is up to destribution to select the driver they want to use
and blacklist the one they don't want. No need to change the kernel.

-- 
Dmitry
