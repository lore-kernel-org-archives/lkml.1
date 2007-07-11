Return-Path: <linux-kernel-owner+w=401wt.eu-S1764468AbXGKNmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764468AbXGKNmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbXGKNl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:41:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:1493 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367AbXGKNlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:41:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KGOX15PQjKCJ7RvhQyWo6PpQfAIFsfuPlSKdR4/sG33IKayxa1jwAsgWxFxYiD06hhhZOHizJ3E/muElTI+HcSZ+dFg1zFy95srrpS6Xvow04Pr4GNt5pi+TxL6sL+5avPTRHOM553Z/bKVTUn+VFCAkC8a+z8s/pk8e6uz2+Bg=
Message-ID: <9a8748490707110641y1796d5dy42d4f744f131fbc9@mail.gmail.com>
Date: Wed, 11 Jul 2007 15:41:53 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Gmail and flowed text (was Re: Correction to LZO1X)
Cc: "Nitin Gupta" <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <a781481a0707110636l3b56a25j174603a5a8af3186@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707110636l3b56a25j174603a5a8af3186@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> [ off the original topic, Cc: list trimmed ]
>
> On 7/11/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> > [...]
> >  #define LZO1X_MEM_COMPRESS     (16384 * sizeof(unsigned char *))
> >  #define LZO1X_1_MEM_COMPRESS   LZO1X_MEM_COMPRESS
> >
> > -#define lzo1x_worst_compress(x) (x + (x / 64) + 16 + 3)
> > +#define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
> >
> >  /* This requires 'workmem' of size LZO1X_1_MEM_COMPRESS */
> >  int lzo1x_1_compress(const unsigned char *src, size_t src_len,
>
> And yet another patch falls victim to format=flowed ...
>
> I need some ideas here myself:
>
> I don't want to subscribe from my university mail account -- I like
> to keep important messages on server, and the account has a
> 100 MB or so limit that wouldn't survive a week of lkml traffic.
>
> Which leaves Gmail, but Gmail has the flowed text disease (that
> cannot be disabled) and although Gmail offers SMTP/POP, our evil
> proxy/NAT setup here wouldn't let me make any use of it to access
> it from some other MUA such as pine/mutt.
>
> I use Paul Jackson's wonderful "sendpatchset" script (when sending
> patches that start new threads), but it's frustrating not to be able to
> reply to existing threads with patches from Gmail itself (from which I
> have subscribed to lkml).
>
> I suspect others must have come across this ... any suggestions?
>

1) talk to the administrators and convince them to allow you to use
gmails SMTP/POP feature with a different MUA so you don't have to use
the web interface.

2) If you have a box available at home (or elsewhere), use that to
relay mail through.

3) Use attachments for patches (sucks, but you may have to).


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
