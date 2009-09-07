Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbZIGGKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbZIGGKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 02:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758950AbZIGGKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 02:10:18 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:57136 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758947AbZIGGKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 02:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=L6yiaCbl06Bojco15iYgf5mUr+8J6HQjWIRW1WYOoCZWrl8zBS6TiV3FevqdO3JepK
         KpXrn8tNrv/FMUAShiCWWqbh8QkQ5wHz+7b6AC9Oca2GKeKyAtHZCHZJWZfj0w9Jsvjd
         /Kc0bLRqoWtYkRdKdKRDiWnPefqJWfV5HmSKQ=
MIME-Version: 1.0
In-Reply-To: <20090907153723.0c984c83.sfr@canb.auug.org.au>
References: <20090907153723.0c984c83.sfr@canb.auug.org.au>
Date: Mon, 7 Sep 2009 09:10:18 +0300
X-Google-Sender-Auth: 57b3790180b1a2f7
Message-ID: <84144f020909062310u37ecdddfw31c6cc9a22ccabd9@mail.gmail.com>
Subject: Re: linux-next: slab tree build failure
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Sep 7, 2009 at 8:37 AM, Stephen Rothwell<sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next build (x86_64 allmodconfig) failed like this:
>
> net/wireless/scan.c: In function 'cfg80211_inform_bss':
> net/wireless/scan.c:499: error: implicit declaration of function 'kmemleak_ignore'
>
> Caused by commit 74ce35c0d2261896ed4d49799311a894520f7a94 ("cfg80211:
> clear cfg80211_inform_bss() from kmemleak reports") from the wireless
> tree (which should have included linux/kmemleak.h into
> net/wireless/scan.c).  Some interaction with the slab tree has exposed
> this.
>
> I have reverted the above commit for today.

AFAICT, you're interested in kmemleak.git, not slab.git. Catalin?

                                Pekka
