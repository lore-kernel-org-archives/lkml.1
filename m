Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbXFMAZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbXFMAZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 20:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbXFMAZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 20:25:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:52370 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbXFMAZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 20:25:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RdYBsfE/fcWcTfS4kMkEiSbdXDBqAV/chomnreJGZudovxy9u/uGO0rHynh95Vd4x8hTJZXzC+XL4Bd+8em9NBpBUieX3C8jDsYvk7CsDKPaLJ/XUeu71S4/Un4zWfzwxGim4EULn/+444WBtfZNIUk+7+cDcldD9VdwUrNrHAs=
Message-ID: <2c0942db0706121725o9621b3bv35fc8ccf563b6fbb@mail.gmail.com>
Date: Tue, 12 Jun 2007 17:25:06 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070612215501.GE13747@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706071530.51552.jesse.barnes@intel.com>
	 <20070612145007.GA5986@ucw.cz>
	 <200706120829.21465.jesse.barnes@intel.com>
	 <20070612213020.GA13747@elf.ucw.cz>
	 <2c0942db0706121438y6d2d2bb5qbe11269691366d20@mail.gmail.com>
	 <20070612215501.GE13747@elf.ucw.cz>
X-Google-Sender-Auth: da9f927b518b0992
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2007-06-12 14:38:28, Ray Lee wrote:
> > Panicking when it's not necessary is anti-social. If the kernel can
> > continue, then it should, unless it's a correctness issue that may
> > cause data corruption. Given that the kernel can even work around the
> > problem now, throwing a panic is even less warranted.
>
> Printk("*********************** WARNING")
>
> is anti-social, too.

Pavel, this warning isn't even going to print on any of your systems.
So it's completely different than the straw-man you're proposing (that
I snipped).

Look, if you want to argue that the stars should go away, then sure,
I'm not going to stop you. But panicking over a BIOS misconfiguration
issue? One that can be corrected by the kernel? That's just plain
stupid.

Ray
