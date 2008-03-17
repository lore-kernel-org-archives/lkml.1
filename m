Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbYCQWl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbYCQWl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYCQWlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:41:21 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:38273 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYCQWlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:41:20 -0400
Message-ID: <fa686aa40803171541t6357d304i2e7e5292f084d09d@mail.gmail.com>
Date: Mon, 17 Mar 2008 16:41:15 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Paul Gortmaker" <paul.gortmaker@windriver.com>
Subject: Re: powerpc: cuImage.* creation error
Cc: "Adrian Bunk" <bunk@kernel.org>, "Kumar Gala" <galak@kernel.crashing.org>,
       "Paul Mackerras" <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080317200754.GA7383@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080317193652.GA9550@cs181133002.pp.htv.fi>
	 <20080317200754.GA7383@windriver.com>
X-Google-Sender-Auth: 56af565ef83ab952
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 2:07 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> In message: powerpc: cuImage.* creation error
>
>  @@ -253,8 +253,8 @@ image-$(CONFIG_TQM8540)                     += cuImage.tqm8540
>   image-$(CONFIG_TQM8541)                        += cuImage.tqm8541
>   image-$(CONFIG_TQM8555)                        += cuImage.tqm8555
>   image-$(CONFIG_TQM8560)                        += cuImage.tqm8560
>  -image-$(CONFIG_SBC8548)                        += cuImage.tqm8548
>  -image-$(CONFIG_SBC8560)                        += cuImage.tqm8560
>  +image-$(CONFIG_SBC8548)                        += cuImage.sbc8548
>  +image-$(CONFIG_SBC8560)                        += cuImage.sbc8560

No, the suffix in the cuImage targets has a 1:1 relationship with dts
files in arch/powerpc/boot/dts/.  If a file doesn't exist there, then
the target cannot be built.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
