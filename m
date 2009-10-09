Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbZJIT7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbZJIT7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbZJIT7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:59:53 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:34929 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZJIT7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HmsuvtGCecJFPsV+GbGibqtbHdOGuSVYmPsQFK/WmikaPDp5xgSRjwkeMLO7G8YJPk
         AXJNaQVh72E8REB9VsP71YnxlLs+jnjktPOFexxnZQV+xbQEU7iaB+661OKVc1sKNz36
         b1sjmBRHpN1gqgvudhxGOSyx1o5lXYQaX4xFo=
Date: Fri, 9 Oct 2009 23:59:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wrong final bzImage build (regading #14270)
Message-ID: <20091009195912.GI5311@lenovo>
References: <4ACF460E.7000901@msgid.tls.msk.ru> <20091009145825.GE5311@lenovo> <4ACF9184.9040104@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACF9184.9040104@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Michael Tokarev - Fri, Oct 09, 2009 at 11:39:48PM +0400]
> Ok, some more to this.
>
> It turns out dash's built-in echo command interprets \nnn octal
> sequences by default, and there's no way to turn that off.  So,
> for example, sed-zoffset command from arch/x86/boot/Makefile
> (which includes \1 \2 etc substitutions for sed), when echoed
> in verbose mode (V=1), produces.. interesting characters (with
> ascii code 1 and 2).
>
> It's not practival to replace V=1's echo with /bin/echo I think.
>
> So I'd say it's not a bug in the build system after all, but
> a bug in dash.  Well, at least this expanding-by-default didn't
> trigger another very-difficult-to-find bug (hopefully), but it
> has good potential.
>
> I'll file a bug report against dash.
>
> /mjt
>

OK, thanks Michael!

	-- Cyrill
