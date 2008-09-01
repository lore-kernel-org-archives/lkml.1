Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYIAKFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYIAKFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 06:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYIAKFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 06:05:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:8607 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYIAKFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 06:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=cO29Y9v+LOLMsBGFRUkbwT+k+RcxvmcnjO6rx6UJv08jULq4ViT143BsqifIKUpHEE
         grIb6cKc5V4V9SYoO16FG7Fl5S2d2IkSbUXUjlfvVH1rCrk48fMBFri++vyWZ4RqsmLp
         z04SJQoLhuLSe32ymcKE/jmhGBEU6cPEPNPl4=
Message-ID: <386072610809010305g2e728e1p282f0a2b8e7ba43e@mail.gmail.com>
Date: Mon, 1 Sep 2008 18:05:19 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: felipe.balbi@nokia.com
Subject: Re: HAVE_CLK (for <linux/clk.h> support)
Cc: "David Brownell" <david-b@pacbell.net>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080901100021.GB7041@gandalf.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805231044.59969.david-b@pacbell.net>
	 <200805271614.55233.david-b@pacbell.net>
	 <31e679430805271701h73ee1eb2p80329900008827f8@mail.gmail.com>
	 <200805271841.16793.david-b@pacbell.net>
	 <386072610809010248l78e9c661i130c3fa4b84b0a3c@mail.gmail.com>
	 <20080901100021.GB7041@gandalf.research.nokia.com>
X-Google-Sender-Auth: 2f1b868e296dc607
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2008 at 6:00 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
> On Mon, Sep 01, 2008 at 05:48:14PM +0800, ext Bryan Wu wrote:
>> Sorry for jumping in so later. I noticed Blackfin does not support
>> HAVE_CLK currently.
>> As the HAVE_CLK dependence is included in the kernel mainline, MUSB
>> parts do not show up in the Kconfig because of lacking of HAVE_CLK.
>>
>> To implement clk infrastructure in Blackfin will be later than merging
>> MUSB Blackfin parts to upstream.
>>
>> Any idea?
>
> dude, you're really late on this one. Now that musb depends on HAVE_CLK
> and we have things working for that. What you can do is locally (on your
> tree) remove the HAVE_CLK dependency so you can keep musb development
> going. But don't push that patch upstream. Meanwhile, you'll have time
> to implement clk framework support for blackfin.
>

Too bad, I just realize this when I try to port my local blackfin
patch for upstream merge.
You're right, currently I remove the dependency locally. So I need to
add a new task to implement clk framework for Blackfin.

OK, another question, do you know where is the latest usb development
git tree, buddy?

Thanks
-Bryan
