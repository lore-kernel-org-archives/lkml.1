Return-Path: <linux-kernel-owner+w=401wt.eu-S1751524AbZLNFj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbZLNFj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZLNFj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:39:26 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52351 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZLNFjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:39:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eoWU63nD2YsIERoZx2F3sW+1VaxP85lk/HOFwOjV5r4q7CCMwPDJw5zLPCY6w2EfnP
         w2RLstFQIDzwTFTi8At5Wp1q+HJccvTQ+AlYqff97tkIaDZHmRS9z9lbIX/203/4gG0M
         auq2u3RtSUweMBtQA0lA9LDHMok/vRu8k6AAQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.01.0912131118280.28039@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr>
	 <9b2db90b0912122323w25d2d815o70d0bd2f1e19a228@mail.gmail.com>
	 <alpine.LSU.2.01.0912131118280.28039@obet.zrqbmnf.qr>
Date: Mon, 14 Dec 2009 07:39:23 +0200
Message-ID: <9b2db90b0912132139m702db437x64a70a98c16667b@mail.gmail.com>
Subject: Re: nconfig v7
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>10x ;)
>
> Ten times what?

Thanks...

>>> - provide the same color scheme as menuconfig
>>
>>As far as colrs are involved, I think it is best to not impose any
>>color scheme. You can never satisfy everyone, and will get into
>>endless fights about which is best.
>
> Well, menuconfig seems to have had the least fights. There was exactly
> one color scheme imposed, and that did not change for years; when themes
> were added, not much happened. There was a bit of discussion and
> submissions about themes (including myself), but in the end, it was
> sort-of agreed upon that four were enough. And they seem to work for
> everybody.
>
>>I believe the current approach in nconfig works best, as I am using
>>the default terminal colors for the main body of text (menus, help
>>text, etc), and only use colors for emphasis (headings, boxes, etc).
>
> No sorry. Black-on-blue does not work very much, for the physical fact
> that blue is recognized as faint. Let me put in some numbers (30,59,11%
> are the common RGB weighting for grayscale/luminance)
>
>  Blue:                       Effective Lum:
>  - xterm standard (#0000EE): 26.18
>  - VGA standard (#0000AA):   18.70
>  Cyan:
>  - VGA (#00AAAA)             119.00
>
> So you see why Midnight Commander, htop, etc. all use Black-on-Cyan for
> their Fn keybar instead of Blue.

I'll go along with you, but only as fat as the highlights are
concerned. I will oppose any kind of color theme for the main body of
text, as it will just lead to arguments about readability, etc., which
I feel no one would win but the loudest complainer. Again, I believe
it is best to make use as much as possible of the colors the user has
picked for her terminal, as she had already made the best choice for
_her_.
