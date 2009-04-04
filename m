Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZDDOey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZDDOey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 10:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZDDOeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 10:34:44 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:29096 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbZDDOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 10:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wvnxTufCCukSPgWtjKzCeXKID/G8ZdsKS1SbGkLjGYbuXZAwVhA/5KRmZjHJkr01gp
         EQyiUhbsvyatfRreQIjSyNuOl4UBK1y3Ct5QnBroXkjdO4GriSHyNLXSGz8RgUDZChbY
         8wDQ0TntwnsBoX9b62wBUVZ8KHlV/BDrK9pJc=
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Andreas Robinson <andr345@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Stoffel <john@stoffel.org>, Alain Knaff <alain@knaff.lu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49D65700.5060202@zytor.com>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
	 <18900.52255.798522.393088@stoffel.org>
	 <1238752196.8118.185.camel@andreas-desktop>  <49D65700.5060202@zytor.com>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 16:34:36 +0200
Message-Id: <1238855676.18423.32.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after enabling checksumming (adler32) and adding an overrun check, based
on your suggestions and objections, the performance advantage of LZO on
the Eee 901 dropped to 67 ms with the fast, and 54 ms with the safe
decompressor. Apparently almost half of the speed boost came from
skipping the checksumming.

At this point I don't think this idea is worth pursuing further, when
LZO is so close to gzip in performance after all.

But I want thank you for discussing this topic and taking my patch
submission seriously.

I hope I did not waste too much of your time and that I will be able to
contribute something more useful next time.

Thanks,
Andreas


