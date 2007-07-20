Return-Path: <linux-kernel-owner+w=401wt.eu-S936416AbXGTUhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936416AbXGTUhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934809AbXGTUhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:37:13 -0400
Received: from barikada.upol.cz ([158.194.242.200]:54026 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127AbXGTUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:37:11 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: Simon Arlott <simon@fire.lp0.eu>, Denis Cheng <crquan@gmail.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
In-Reply-To: <20070720170743.GF14791@parisc-linux.org>
References: <1184489571313-git-send-email-crquan@gmail.com> <4699EEA9.6070709@simon.arlott.org.uk> <20070720170743.GF14791@parisc-linux.org>
Date: Fri, 20 Jul 2007 22:50:42 +0200
Message-Id: <E1IBzQw-0000Im-55@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Date: Fri, 20 Jul 2007 11:07:43 -0600

> Of course, we can't add this flag to Lindent until it's widely
> circulating amongst the distributions.  Perhaps we can add this to
> Lindent in the meantime:
>
> sed -i -e 's/^\t*      \(\w*:\)/ \1/' "$@"
>
> which will replace the leading tabs and spaces with one space.
> It should leave case labels unmolested, as they should be indented with
> tabs, not 6 spaces.
>
> Any regexp ninjas want to have a go at something better?

I'm the one. Trying to write portable, optimized and easy to
understand scripts [0].

Please, describe more what must be done, and i will do it. Case labels
are handled very strangely in you example.

[0] <E1HwY9K-0008Jz-CG@flower>
____
