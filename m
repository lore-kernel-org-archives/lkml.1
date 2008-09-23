Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYIWTky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYIWTky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbYIWTkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:40:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:2669 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYIWTkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=AJhMZ+mDv5JWeAGeNiTtxIg4SdxGoFszUlNATSSSHgu3V0WAOQ/pgiez57yj1DlkXT
         CVhUHCk+tSwLnEmz1pKKx4a4kHYHc0r5LRdWqlRVRgM0reWabr5tR/IfcIP6dXZkTe2h
         6dxVbRPr0fu/aRpF3knHf0RBbCLsHgE8dEE9Q=
Message-ID: <70318cbf0809231240i19b2fa1fq7336cad1caac88ab@mail.gmail.com>
Date: Tue, 23 Sep 2008 12:40:40 -0700
From: "Chris Li" <lkml@chrisli.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
Cc: "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <s5hhc86ae7r.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <s5hbpyny7bl.wl%tiwai@suse.de>
	 <alpine.LFD.1.10.0809181154020.12224@bombadil.infradead.org>
	 <48D36D02.4090003@cateee.net> <s5hy71oyviu.wl%tiwai@suse.de>
	 <70318cbf0809191655m89e4b4fo68c3693487afed98@mail.gmail.com>
	 <s5hk5d4xzw0.wl%tiwai@suse.de>
	 <70318cbf0809221225i5be0ce6eh3ac09d8bf61cc2d7@mail.gmail.com>
	 <s5hr67bumiq.wl%tiwai@suse.de>
	 <70318cbf0809231115r506db98etd87b67a590ba6eae@mail.gmail.com>
	 <s5hhc86ae7r.wl%tiwai@suse.de>
X-Google-Sender-Auth: 078e1cb916a50e6d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:50 AM, Takashi Iwai <tiwai@suse.de> wrote:
> Well, it is not so easy, too.
> The good-working reverse selection with dependency checks is a
> feature we've long for in Kconfig, but it hasn't been implemented
> because it could easily introduce a messy dependency loop, or some
> cases are not easily resolvable.

What I describe is a simpler version of that. The key difference is that,
I only work out the dependency base on a distro config file. So there
is only one set of config value to generate a module instead of many
combo in the more general case. I think that will cover 80 percent of
what user want. If you have a known all config file, the reverse selection
is easy resolvable.

>
> Anyway, the development of reverse-selection should involve with Sam
> and other Kbuild maintainer/developers.

Care to CC them? I think most likely you need to touch the current
kconf for "make diet" any way.

Thanks

Chris
