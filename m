Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0CAD6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 22:58:17 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39662 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab0CAD6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 22:58:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BblKLtYSInRoYB+mMpHOWZHrL5bAQrhKvSOUaSzczltt6iF2pV9mZ+WWoWAoZv4CdW
         v++bce5NClRVMxwz3Ol7MhkLiJCDGelzxWHGFUur6/OQ8J9qBMMFqw2I8uEP15iMuah2
         +1RRlVXWeRofMNgrsfSvnOqz3j9aoXeFoNOUs=
MIME-Version: 1.0
In-Reply-To: <4B76BD0B.2010307@gmail.com>
References: <4B76BD0B.2010307@gmail.com>
Date: Sun, 28 Feb 2010 20:58:14 -0700
X-Google-Sender-Auth: 03a5571c183eab1a
Message-ID: <e9c3a7c21002281958u4ee6fb94p55b7c5069dd08be5@mail.gmail.com>
Subject: Re: [PATCH] iop-adma: redundant/wrong tests in iop_*_count()?
From: Dan Williams <dan.j.williams@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 7:54 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> When we reach the loop, len is at least 1, we only stay in the loop when
> len is at least MAX_BYTE_COUNT + 1, MAX_BYTE_COUNT is subtracted in each
> iteration. So when we leave the loop, or didn't take it, len is at least 1.
> Testing whether len is non-zero appears redundant.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Or are the tests off by one? Then we'll need a different patch...

No, not off by one, just redundant.

Applied, thanks.

--
Dan
