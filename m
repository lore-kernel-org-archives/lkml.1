Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZLVTIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZLVTIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZLVTIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:08:48 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58058 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZLVTIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:08:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FRb+fZe1m3OS1OZ6aZa4KrucBhRCraleFIquPcnuK1/zJ260Ij0aMBefhnWPh5sJjM
         2rgm8CuA/AxCCxdfA/y7OuALCLDKGKZb+0jzMtQSF9A7BMzvMF1MLJyTU6BkDd7eA5eT
         qvIWNhmO5DhhladyuMUMJ4IWrMrKJuccNVoGE=
MIME-Version: 1.0
In-Reply-To: <20091206192841.GA23088@frolo.macqel>
References: <20091206192841.GA23088@frolo.macqel>
Date: Tue, 22 Dec 2009 20:08:46 +0100
X-Google-Sender-Auth: 645c2cc6360042e7
Message-ID: <10f740e80912221108v685ce65k2715ff96733bde43@mail.gmail.com>
Subject: Re: [PATCH m68k resent] allow ioremapping top of memory
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 6, 2009 at 20:28, Philippe De Muyter <phdm@macqel.be> wrote:
> The test in __ioremap to reject memory ranges crossing the 0 boundary
> rejects also memory ranges ending at the end of the memory.  Fix that.

Thanks, will take it.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
