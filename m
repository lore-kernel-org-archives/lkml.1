Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbYBVMIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbYBVMIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYBVMIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:08:36 -0500
Received: from hs-out-0708.google.com ([64.233.178.249]:39926 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbYBVMIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RGczHUEu6u8baL8PhwCreJc/FeJQTEBSYiK8cAArx5I99aWr46uL8fTT7s7Q52nsJsj2al7oxvBGjg4zFLvxmjloP/oFfXDEZInU7PIG6TNqppOoSrgC8NYCj7bqYkw4fuN460S6UXqdpooN5Q/HjQF9jEKFzj/ch3ybOiU7280=
Message-ID: <97a0a9ac0802220408m2c49f59aj81e2d45860bbc7d4@mail.gmail.com>
Date: Fri, 22 Feb 2008 05:08:33 -0700
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Cc: "Michael Buesch" <mb@bu3sch.de>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, viro@ftp.linux.org.uk
In-Reply-To: <97a0a9ac0802212024w62dbfb03ye62c51744e853b36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
	 <200802191141.26952.mb@bu3sch.de>
	 <97a0a9ac0802191644x693cd34cq6b167756df9c65f4@mail.gmail.com>
	 <200802201544.05192.mb@bu3sch.de>
	 <20080220193709.GD21139@uranus.ravnborg.org>
	 <97a0a9ac0802212024w62dbfb03ye62c51744e853b36@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 9:24 PM, Gordon Farquharson
<gordonfarquharson@gmail.com> wrote:
> Hi Sam
>
>
>  On Wed, Feb 20, 2008 at 12:37 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
>  >  Option 1) is the worst of the three as that can cost
>  >  of many hours bug-hunting.
>  >  Option 3) may seem optimal but I do not like to add more
>  >  complexity to this part of the build. And really I do not
>  >  know a reliable way to detech when we do cross builds anyway.
>  >
>  >  Leaving us with option 2) that is simple, strighforward and harmless.
>
>  Are you willing to sign off on and commit the patch?

I realize that I forgot to put

Signed-off-by: Gordon Farquharson <gordonfarquharson@gmail.com>

in my original email.

Gordon

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
