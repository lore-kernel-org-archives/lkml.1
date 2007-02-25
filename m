Return-Path: <linux-kernel-owner+w=401wt.eu-S933691AbXBYK07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbXBYK07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933694AbXBYK07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:26:59 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:64466 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691AbXBYK06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:26:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gGNDJmNcVdiJaKaUi+P8r6tVCVQDmd0dEQUtVlWk4LCLDi2traibXxI0c1WYBkzKPZI57nvHuTws5rl5illwSk9P+tlKHCs0+nK7KNd+5u5n5jU3f27P5BdQnpHbVXH5aLlcPpTKO5yau9hUe1kjMYTwmLNMMCPFB+Pa17ImvFA=
Message-ID: <cb7bb73a0702250226k53369655vc9c4e5a71c337a8c@mail.gmail.com>
Date: Sun, 25 Feb 2007 11:26:57 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "James Simmons" <jsimmons@infradead.org>,
       "Luca Tettamanti" <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@osdl.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1172351769.4415.5.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org> <1172153358.4306.17.camel@daplas>
	 <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
	 <1172161290.4198.12.camel@daplas>
	 <cb7bb73a0702221108r161441ebt61886ce67746f389@mail.gmail.com>
	 <1172187249.4279.7.camel@daplas>
	 <cb7bb73a0702230534o4e2c7e9frd5f2b05accf18c05@mail.gmail.com>
	 <1172300694.4109.50.camel@daplas>
	 <cb7bb73a0702240116g33a9b5bv2e3668a536a70938@mail.gmail.com>
	 <1172351769.4415.5.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Sat, 2007-02-24 at 10:16 +0100, Giuseppe Bilotta wrote:
> >
> > Keep in mind that setting nvidiafb to totally ignore the EDID (either
> > by not compiling in EDID support or by using e.g. the ignoreedid patch
> > I had proposed) the snow effect is extremely reduced,
>
> I did not know that, just scanned the entire thread. Try this patch, it
> makes use of fb_ddc_read*() which I believe has extra steps to prevent
> display corruption.  It also incorporates Luca's i2c fix.

Applied. No noticeable difference, in the sense that the EDID debug
output is still the same and so is the snow effect.

-- 
Giuseppe "Oblomov" Bilotta
