Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbZFUXkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbZFUXkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 19:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZFUXk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 19:40:29 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:50652 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbZFUXk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 19:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=dyEvjgoFNRwhV5z+tos4s6o5SefblydO5dZnYZMv/CZfvATyxS1lwat4EZud7AE8zn
         4mrV8FBR/Mx4Yfu9pZnUtxXXWXnZvbZvMQQNjpu2y7QWDl//TaRu32V5IMV2AfbYgf9n
         yqQUl4CXkCsGHNOHAmLQlPON65LJElLFq3oGQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared - system is dreadfully slow)
Date: Mon, 22 Jun 2009 01:45:03 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80; KDE/4.2.3; i686; ; )
Cc: elendil@planet.nl, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090621.141950.160759111.davem@davemloft.net> <20090621.155756.100422570.davem@davemloft.net> <20090621.161343.181101055.davem@davemloft.net>
In-Reply-To: <20090621.161343.181101055.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906220145.03923.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009 01:13:43 David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sun, 21 Jun 2009 15:57:56 -0700 (PDT)
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Date: Mon, 22 Jun 2009 00:34:22 +0200
> > 
> >> Lets get over this quickly, since you seem to have such a great
> >> insight into running IDE layer here is a little proposition..
> >> 
> >> ACK?  [ If not than can we please get back with the program? ]
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> 
> I've created a new IDE development tree at:
> 
> 	master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git
> 
> and the first patch is below.
> 
> I'll ask the patchwork folks to add an IDE group so we can manage
> patches posted here.
> 
> I'm going to treat IDE as pure legacy, rather than as competition
> with the PATA drivers which is what people whould be moving over to.
> 
> And more importantly I refuse to apply any driver patch that isn't
> actually tested on said hardware.
> 
> ide: Take over as maintainer.

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

You have my full support (don't hesitate to ping me if you need some
help) and I hope that the last few years of my of work would make your
job relatively easy and painless.

I would also like to use this occasion and thank all the people who
have been contributing to the project during my reign.  Thanks!!

> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  MAINTAINERS |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d47043..487aaea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2802,10 +2802,10 @@ S:	Supported
>  F:	drivers/scsi/ips.*
>  
>  IDE SUBSYSTEM
> -P:	Bartlomiej Zolnierkiewicz
> -M:	bzolnier@gmail.com
> +P:	David S. Miller
> +M:	davem@davemloft.net
>  L:	linux-ide@vger.kernel.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6.git
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6.git
>  S:	Maintained
>  F:	Documentation/ide/
>  F:	drivers/ide/
