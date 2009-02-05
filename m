Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZBERmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZBERmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZBERmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:42:32 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:15327 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbZBERmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:42:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TIPvzsvcGO+f+ADjWahRM/qYV1r4HodqrM5IVpvfTOfvbGMCiTt1tMlheXzyuIZnop
         Mr1VzF9X2a/tc75qjukYm7BGVhHLRS2xoMfBYtDJYTQd2Y6d7FVKJQRGQhGHH9QuMYX9
         bfBIzFnxz0J+eqFjjgNQ5byCfQhHPohNvgU6A=
Message-ID: <498B24FA.2020605@gmail.com>
Date: Fri, 06 Feb 2009 02:42:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Brian Gerst <brgerst@gmail.com>,
       Xen-devel <xen-devel@lists.xensource.com>, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: style fascism for xen assemblies
References: <4983AC87.5000304@goop.org> <498A87B5.3020808@gmail.com> <20090205150028.GD23903@elte.hu> <498B0E13.7060604@gmail.com> <498B226A.2020900@goop.org>
In-Reply-To: <498B226A.2020900@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jeremy Fitzhardinge wrote:
> I don't really like what you've done here.  There are two problems:
> 
>    * If you're going to convert comments of the form
> 
>      /* This is a small comment which
>         happens to be longer than a line. */
>         
>      then you should convert it to full winged-style, rather than just
>      sticking '*' on the front of the second line.

I find fully winged style a bit excessive when a comment is in the
middle of code and not very long so I kind of just chose middleground.

>    * All the big block comments look crowded and cramped now, which
>      makes them harder to read and maintain.  All those '*'s are just
>      visual noise. (They make a bit more sense in C code to distinguish
>      comment from code, but asm code looks so different from comment
>      that they're not necessary here.)
> 
> But Ingo's already pulled it, so I guess I'm stuck with it.

Yeap, I really didn't expect everyone to be happy about it.  Style
cleanups always get ugly, so the fasicm joke on the subject.  Anyways,
if you feel strong against it, please feel free to change.  I
personally don't mind one way or the other.  I just wanted to make
things more consistent while at it.

Thanks.

-- 
tejun
