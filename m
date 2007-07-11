Return-Path: <linux-kernel-owner+w=401wt.eu-S1764998AbXGKNhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764998AbXGKNhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764828AbXGKNg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:36:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:15701 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764369AbXGKNgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:36:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=S0ifCz4z56OVjEly3s4jPYDf6oPpbOD3x857Zyc0f/L+cy3sPURhryFo13/tCOYt72yj6+/LPkH39leVAlrfuaeVnnKHl5vm0q37/ZsQXCPka5bNsuNSBqmUXuQgvDmWsMBzZVilfIKTyTZHwIB2UyxFVpjaSkvQY8/lB5rHlVA=
Message-ID: <a781481a0707110636l3b56a25j174603a5a8af3186@mail.gmail.com>
Date: Wed, 11 Jul 2007 19:06:23 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Gmail and flowed text (was Re: Correction to LZO1X)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ off the original topic, Cc: list trimmed ]

On 7/11/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> [...]
>  #define LZO1X_MEM_COMPRESS     (16384 * sizeof(unsigned char *))
>  #define LZO1X_1_MEM_COMPRESS   LZO1X_MEM_COMPRESS
>
> -#define lzo1x_worst_compress(x) (x + (x / 64) + 16 + 3)
> +#define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
>
>  /* This requires 'workmem' of size LZO1X_1_MEM_COMPRESS */
>  int lzo1x_1_compress(const unsigned char *src, size_t src_len,

And yet another patch falls victim to format=flowed ...

I need some ideas here myself:

I don't want to subscribe from my university mail account -- I like
to keep important messages on server, and the account has a
100 MB or so limit that wouldn't survive a week of lkml traffic.

Which leaves Gmail, but Gmail has the flowed text disease (that
cannot be disabled) and although Gmail offers SMTP/POP, our evil
proxy/NAT setup here wouldn't let me make any use of it to access
it from some other MUA such as pine/mutt.

I use Paul Jackson's wonderful "sendpatchset" script (when sending
patches that start new threads), but it's frustrating not to be able to
reply to existing threads with patches from Gmail itself (from which I
have subscribed to lkml).

I suspect others must have come across this ... any suggestions?

Satyam
