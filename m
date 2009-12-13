Return-Path: <linux-kernel-owner+w=401wt.eu-S1751334AbZLMHX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbZLMHX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 02:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZLMHX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 02:23:56 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:44032 "HELO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751189AbZLMHXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 02:23:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kuL02yUpIa9USVTkSKpqrBRICjx/uXgU8UB8XqGtgTSkfqL7WpzWDDp3ItVdLS0Wqu
         mHJS0aYz17V3zoF8OxJAMAVw31rfG8o0urUxDcHnX+BoCaE3WNBPjfVMNdfbaLEXLvA6
         BdBG1MGsmN9nBRQDlm4VC78Hs2iA8SSilPhsk=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr>
Date: Sun, 13 Dec 2009 09:23:52 +0200
Message-ID: <9b2db90b0912122323w25d2d815o70d0bd2f1e19a228@mail.gmail.com>
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

Hello.

On Fri, Dec 11, 2009 at 9:55 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> Hi,
>
>
> I gave nconfig a try, and here are a few suggestive points:

10x ;)

> - provide the same color scheme as menuconfig

As far as colrs are involved, I think it is best to not impose any
color scheme. You can never satisfy everyone, and will get into
endless fights about which is best. I believe the current approach in
nconfig works best, as I am using the default terminal colors for the
main body of text (menus, help text, etc), and only use colors for
emphasis (headings, boxes, etc). This is based on the belief that
users have already chosen the colors which work best for them, and are
already using them in their teminal's config.

> - I get a visual glitch (see Exhibit A below) in General setup (patch
>  slapped onto 2.6.32); the left frame part is missing.

I cannot reproduce this. Can you provide some more details? (e.g.,
which terminal, $LINES, $COLUMNS, $TERM)

> - For symbol info, it would be cool if it wrapped the "Selected by"
>  line (menuconfig also "suffers" from this), because that one can
>  get exceptionally long and awkward to scroll.

I took a look at the patch by Vadim Bendebury, should be easy to adapt nconfig.

> - I certainly like F4-Config-ShowAll :)  but it has some glitches
>  interfering near ARCH_DEFCONFIG (see Exhibit B).

Thanks for catching this. It is a by-product of the code for
presenting everything inside a single menu. Easily fixed in the next
version. By the way, is anyone using this option at all? It would much
simplify the code if I did not have to support the one giant menu
option.

Chhers,
Nir.
