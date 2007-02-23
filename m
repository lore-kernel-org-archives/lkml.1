Return-Path: <linux-kernel-owner+w=401wt.eu-S932354AbXBWNeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbXBWNeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 08:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932364AbXBWNeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 08:34:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:6264 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbXBWNeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 08:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NZKrEXypv05pvBQatp/Ovx80HcBo7OHNKN8FFr/36Uwc6Hjyojz2XEZ/qzPisQSwyY+mHdd+h4hINHMXaq0/vOViwWv7qgeyOns3ees6abM4tVmNaE6lCi147odPAXw+z4cTHT8H9S9l/pTVsNJ5VoRfldqpDoUYeg0VfaQzct0=
Message-ID: <cb7bb73a0702230534o4e2c7e9frd5f2b05accf18c05@mail.gmail.com>
Date: Fri, 23 Feb 2007 14:34:15 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "James Simmons" <jsimmons@infradead.org>,
       "Luca Tettamanti" <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@osdl.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1172187249.4279.7.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org> <1172101406.4217.16.camel@daplas>
	 <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
	 <1172133646.4086.5.camel@daplas>
	 <cb7bb73a0702220548s55380f7fk995726ffd349823b@mail.gmail.com>
	 <1172153358.4306.17.camel@daplas>
	 <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
	 <1172161290.4198.12.camel@daplas>
	 <cb7bb73a0702221108r161441ebt61886ce67746f389@mail.gmail.com>
	 <1172187249.4279.7.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Thu, 2007-02-22 at 20:08 +0100, Giuseppe Bilotta wrote:
> > No, it doesn't. I've tried all the methods from 640x480 to 1600x1200,
> > and they /all/ come up snowy. This is starting to look queerer and
> > queerer. I've also tried changing vf min and max as you suggested:
>
> Before we proceed, do you agree that the patch will allow you to change
> video modes without disabling DDC support?  So this is still a valid
> fix?

You're right, I hadn't realized that. I can now access all the sizes
from 640 to 1600, so I would say the fix is valid.

> When does your display become snowy? Is the snow constant or does it
> only snow when doing heavy text operations, such as scrolling?

The snowy is constant and abundant, and it seems to be independent of
video size (640 through 1600) and screen occupation (single prompt
line to fullscreen mc session) and usage.

> I presume that X's nv driver or vesafb does not exhibit this problem?

X's nv gives a very clean display, /unless/ I load nvidiafb before: if
I modprobe nvidiafb (it's a module, and it's blacklisted precisely for
this reason), then the screen is very snowy with X's nv too.

-- 
Giuseppe "Oblomov" Bilotta
