Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYADRTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYADRTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 12:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYADRTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 12:19:04 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:24747 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbYADRTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 12:19:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XRk6ttZR7EaI2s8QofA7yLyO5W6WHnx8kHWxFhRna3ZmZxj5jfvEUHtplCoCiSYT5PM7wrinYPUd08JxBQDmK48AWUBXPO+t9URKkMhjuZR3Ah7VVzRkjI0r+Odp60Dp5/5IzyLrSm4Vuxsty0ZuJucTyv7fmlLsJNy2PCg6GEY=
Message-ID: <4d8e3fd30801040918m4b928eebmb37e2bce5425715@mail.gmail.com>
Date: Fri, 4 Jan 2008 20:48:59 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] profile: further Codying Style fixes
Cc: mingo@helte.hu, "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080104171326.GA31382@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080104152521.620e4e80@paolo-desktop>
	 <20080104171326.GA31382@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/08, Sam Ravnborg <sam@ravnborg.org> wrote:
> > @@ -408,9 +406,8 @@ void profile_hits(int type, void *__pc, unsigned int
> nr_hits)
> >  	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
> >  	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
> >  }
> > -#endif /* !CONFIG_SMP */
> > -
> >  EXPORT_SYMBOL_GPL(profile_hits);
> > +#endif /* !CONFIG_SMP */
>
> The symbol is now not exported for non-SMP builds which is a change in
> functionality.
> And thats not acceptable for pure clean-up patches.

Right, i'll update the patch.
Thanks Sam.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
