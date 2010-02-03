Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab0BCQH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:07:28 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:65348 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab0BCQHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:07:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tRxpMoZmlbRcH2dsZkf4imgJuNF6dcmhYH+mxUccr0i1oT6VvPjiSdnkhcZl4xrKd5
         6zO0eLGP7ZQSv273t7qK56fFnYislfiGsEbBBQWatlXHTSfEql3AjHDpB3pFgovihRmq
         rCYAeIaexcK+nZX97mMkjMpt/B3alyGLdeMDw=
MIME-Version: 1.0
In-Reply-To: <1265043026-24987-3-git-send-email-dvhltc@us.ibm.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
	 <1265043026-24987-3-git-send-email-dvhltc@us.ibm.com>
Date: Wed, 3 Feb 2010 17:07:24 +0100
X-Google-Sender-Auth: 439f460df87613f6
Message-ID: <520f0cf11002030807t48678b82ye56624840e6f9ce3@mail.gmail.com>
Subject: Re: [PATCH 2/3] trace-cmd: fix printf compile warnings
From: John Kacur <jkacur@redhat.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 5:50 PM, Darren Hart <dvhltc@us.ibm.com> wrote:
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> ---
>  trace-read.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/trace-read.c b/trace-read.c
> index a04c85b..5befaba 100644
> --- a/trace-read.c
> +++ b/trace-read.c
> @@ -216,7 +216,7 @@ static void read_rest(void)
>                r = read(input_fd, buf, BUFSIZ);
>                if (r > 0) {
>                        buf[r] = 0;
> -                       printf(buf);
> +                       printf("%s", buf);
>                }
>        } while (r > 0);
>  }
> --
> 1.6.3.3
>

Oh! Obviously correct, thanks Darren.
