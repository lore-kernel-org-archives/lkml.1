Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYCVAKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYCVAKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 20:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYCVAKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 20:10:46 -0400
Received: from hs-out-0708.google.com ([64.233.178.248]:22200 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYCVAKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 20:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nEdlDpGRELzAv67n+EdNtYEkp1DVNDUFolCQ2ENWiGt/xELYOw21Zle+NN3i80u5jKbddJB2eJhoGGHz5Kj+iaj6If9OHrlNF3jyyS5q8y6AMlLbTsZYsWGor/A1m3PqygPSqU0IGbkV4jnKmCRBEfL4csucudJw47P4U6/Up9k=
Message-ID: <9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com>
Date: Sat, 22 Mar 2008 01:10:40 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Chris Wright" <chrisw@sous-sol.org>
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <20080321224333.400857992@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080321224250.144333319@sous-sol.org>
	 <20080321224333.400857992@sous-sol.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/2008, Chris Wright <chrisw@sous-sol.org> wrote:
> -stable review patch.  If anyone has any objections, please let us know.
>  ---------------------
>
I don't see how this one fits this criteria from
Documentation/stable_kernel_rules.txt :

...
 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).
...

As I see it, this patch is quite trivial and does not fix any "real problem".
How come this is suitable for -stable?

I have no objections to the patch "as such", I just don't think it
makes sense for -stable.


>  From: David S. Miller <davem@davemloft.net>
>
>  Upstream commit: a442585952f137bd4cdb1f2f3166e4157d383b82
>
>  Signed-off-by: David S. Miller <davem@davemloft.net>
>  Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>  Signed-off-by: Chris Wright <chrisw@sous-sol.org>
>
>  ---
>   drivers/net/niu.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
>  --- a/drivers/net/niu.c
>  +++ b/drivers/net/niu.c
>  @@ -33,8 +33,8 @@
>
>   #define DRV_MODULE_NAME                "niu"
>   #define PFX DRV_MODULE_NAME    ": "
>  -#define DRV_MODULE_VERSION     "0.6"
>  -#define DRV_MODULE_RELDATE     "January 5, 2008"
>  +#define DRV_MODULE_VERSION     "0.7"
>  +#define DRV_MODULE_RELDATE     "February 18, 2008"
>
>   static char version[] __devinitdata =
>         DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
>

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
