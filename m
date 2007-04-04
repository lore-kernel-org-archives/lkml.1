Return-Path: <linux-kernel-owner+w=401wt.eu-S1751024AbXDDUmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbXDDUmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbXDDUmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:42:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:20442 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbXDDUmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K+MwO7p0jAzC95mcSkihmqJFRmfph+CjtImK2e2L6NDGv6f9Iam5zBLB3tnKyFCy+I3pJUm7gUoTlUqdeITCXE5kIqhRlp9xbZ756jSferDS5foWxmKXDiPph7XN9CSGDa4PeBIyAZqE+JRPJ/RIbnYEF2YsMLeeWTWFLOYOk6Y=
Message-ID: <d120d5000704041342o3e32ee2fya9a335cfd2469a52@mail.gmail.com>
Date: Wed, 4 Apr 2007 16:42:12 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Tony Lindgren" <tony@atomide.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <dbrownell@users.sourceforge.net>
In-Reply-To: <Pine.LNX.4.61.0704042205040.22282@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11757099691323-git-send-email-tony@atomide.com>
	 <11757100143517-git-send-email-tony@atomide.com>
	 <11757100163760-git-send-email-tony@atomide.com>
	 <11757100181189-git-send-email-tony@atomide.com>
	 <11757100214151-git-send-email-tony@atomide.com>
	 <11757100242980-git-send-email-tony@atomide.com>
	 <1175710026446-git-send-email-tony@atomide.com>
	 <11757100281957-git-send-email-tony@atomide.com>
	 <20070404120025.4c5548dc.randy.dunlap@oracle.com>
	 <Pine.LNX.4.61.0704042205040.22282@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> On Apr 4 2007 12:00, Randy Dunlap wrote:
> >
> >> +static int __init fpga_init(void)
> >> +{
> >> +    if (machine_is_omap_h4()
> >> +                    || machine_is_omap_h3()
> >> +                    || machine_is_omap_h2()
> >> +                    || machine_is_omap_perseus2()
> >> +                    )
> >
> >Perhaps there is nothing in CodingStyle for if () continuation
> >lines.  Looks like it is needed.  This is ETOOMUCHINDENTATION by
> >at least one tab.  Should be more like:
> >
> >+      if (machine_is_omap_h4()
> >+          || machine_is_omap_h3()
> >+          || machine_is_omap_h2()
> >+          || machine_is_omap_perseus2())
>
> My stance, || goes at EOL, and final ) not standalone:
>
>        if (foo ||
>          bar ||
>          baz ||
>          etc)
>                do_something;
>

I personally ident multi-line conditionals in "if" and "while" with
tabs to the keyword level, then pad with spaces so 2nd+ line starts in
the same column as first part of the condition (i.e one column to the
right from opening paren). Logical operation goes to EOL.

Also with multi-line condition and single-line body I often use braces
to separate them better.

-- 
Dmitry
