Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZETMdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZETMdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZETMdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:33:13 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:34253 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZETMdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:33:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TEPJVXl4POS3w5zonPoxvuhyTsTIOq4kX5EXVw/krv6vRYETPbdG3SD17pkHtpWqH9
         /25jx/YDhvuwKm5zpDet7vHLoOXHfT6NnXJna6QPwhfuTdj7GQ0DuUgGEsJqnKbtGBhN
         7UKc9cdkASlJ0NS5/b/5t9sMIQV+QqB4u1dek=
MIME-Version: 1.0
In-Reply-To: <200905191103.03749.hartleys@visionengravers.com>
References: <200905191103.03749.hartleys@visionengravers.com>
Date: Wed, 20 May 2009 15:33:13 +0300
X-Google-Sender-Auth: 2bc04fcb205c5361
Message-ID: <84144f020905200533j2e1debc1i97e0dbb96ef0edf6@mail.gmail.com>
Subject: Re: [PATCH] mm/slub.c: change printk()s to pr_*() notation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 9:03 PM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> Change all the printk()s in mm/slub.c to the pr_*() notation.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 65ffda5..2805b7f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -338,25 +338,25 @@ static void print_section(char *text, u8 *addr, unsigned int length)
>
>        for (i = 0; i < length; i++) {
>                if (newline) {
> -                       printk(KERN_ERR "%8s 0x%p: ", text, addr + i);
> +                       pr_err("%8s 0x%p: ", text, addr + i);

Hmm, isn't the whole point of pr_err() that you override pr_fmt() to
include your subsystem name?
