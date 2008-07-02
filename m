Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYGBXXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYGBXXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYGBXXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:23:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:12700 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYGBXXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=FTKVQ2wPtVZjQ8en8a1FPbxrQemT2z6J9lEevcS6Biu4zVEUkyB/gklF1Yn5n+H27+
         FXGnsP6Uph1up1sHYDcysec2aCiQIDpmx1V3CnBOYrtc2Gav3gw6zGeZkEECqB4ciy2k
         tIJw+4f15JzAvnCPTr/yznsRVi3D6Xx4G7ph0=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] PalmTX initial support
Date: Thu, 3 Jul 2008 01:24:53 +0200
User-Agent: KMail/1.9.9
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <200807022232.47294.marek.vasut@gmail.com> <200807030053.00019.marek.vasut@gmail.com> <20080702231415.GI19143@flint.arm.linux.org.uk>
In-Reply-To: <20080702231415.GI19143@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807030124.53585.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Thursday 03 of July 2008 01:14:15 Russell King - ARM Linux napsal(a):
> On Thu, Jul 03, 2008 at 12:52:59AM +0200, Marek Vasut wrote:
> > ok, I fixed what I was able to grasp. That is :
> >
> > -Are these useful? + Dittos
> > -Don't you have to configure GPIO47 as a GPIO to change its state?
> > Since you don't, and I assume you've tested this, I think you've
> > proven that you can delete the fiddling with GPIO47.
> >
> > Actually GPIO47 was set up before by palmos (since Im not booting from
> > clean state, but from palmOS) so it wasnt necessary to set it up again in
> > linux and it didnt cause any problems. Booting it from clean state would
> > cause problems, so I fixed it.
>
> Bear in mind then that it may work for the first time you enable IrDA,
> but if you subseqently disable and re-enable it, GPIO47 will be assigned
> to the UART instead.
It works when enabled and disabled multiple times, I tested that.
>
> > That's it, but what I still dont understand is the pxa branch (and new
> > PWM stuff). Im currently using mainline (linus's tree), so that's not the
> > tree I should use ?
>
> from memory:
>
> http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-2.6-rmk pxa
>
> where 'http:...' is the URL and 'pxa' is the branch name.  It's currently
> quite a bit older than mainline at the moment.

Ok, so I should switch to pxa or pxa-pwm (and update the pwm) or continue 
working against mainline (without updating the pwm and ac97)?

Thanks
