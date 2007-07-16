Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbXGPXPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbXGPXPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbXGPXPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:15:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:26922 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbXGPXPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ibCWok3W4x4KxkX2I1EKaw5OowMtM4p9KcJ8+Fq/aG8jRUSo/wRd5MnEYM2NqN776vjAyYvPaYO/9cQYxpovaUwQ87AOcM/NYpc+9lPcbDbKOVfQWccwEcYEkflKbp1N8oqKo1Juoqc+d9xUhPS0kpzwz8tV4z73EaUE8oF5Eyk=
Message-ID: <2c0942db0707161615g4bdf825ar51464ba564a823e2@mail.gmail.com>
Date: Mon, 16 Jul 2007 16:15:28 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Bodo Eggert" <7eggert@gmx.de>,
       "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <469BF9A8.20306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8FO1e-2jW-35@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
	 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	 <469BF104.1040703@gmail.com>
	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	 <20070716235438.1bdd0722@the-village.bc.nu>
	 <2c0942db0707161553u5d55724u82424b3ffbbd79f7@mail.gmail.com>
	 <469BF9A8.20306@gmail.com>
X-Google-Sender-Auth: 91338d03aa772aeb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Rene Herman <rene.herman@gmail.com> wrote:
> Yes but it's also an argument that the 4K stacks don't make the _current_
> situation without CONFIG_4KSTACKS selected worse and given that you trust
> that current situation, that leaves you without your argument :-)

Heh :-). No, it's not a question of trust. First and foremost, it's
that there are still users who say that they can crash a current
4k+interrupt stacks kernel, while the 8k without interrupt stacks is
fine.
