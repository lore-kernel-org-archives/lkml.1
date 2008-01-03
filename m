Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYACXnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYACXnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYACXnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:43:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:13618 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYACXm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VvBuO9C1JFZqZiyrF5Y4Ql3bhsRzfyfCS5nJQpI9mSgSHD6m+ocuFUgKLDoCqv8BEIzfLcDbi5TICZQELHTLgnhfeYCzADfrYGxlF1PtSPmmCDYuzCNbZv1aJtgtGUJqC5iixH4p2F0+nypsnFQy/QXw8I5u8PfLPNC4vDKokYo=
Message-ID: <9a8748490801031542m1f640731m12c96c59df967416@mail.gmail.com>
Date: Fri, 4 Jan 2008 00:42:58 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Subject: Re: [PATCH] This patch to printk.c fixes a few errors reported by checkpatch.pl
Cc: linux-kernel@vger.kernel.org, bunk@kernel.org
In-Reply-To: <20080104001446.66f0c110@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080104001446.66f0c110@paolo-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2008, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
> This patch to printk.c fixes a few errors reported by checkpatch.pl
>
[...]
> -               for (a=console_drivers->next, b=console_drivers ;
> -                    a; b=a, a=b->next) {
> +               for (a = console_drivers->next, b = console_drivers ;

I would say that if you are modifying this line anyway you should make it read

               for (a = console_drivers->next, b = console_drivers;

(the change is the removal of the space before the ';' at the end of the line)

otherwise I think it looks sane enough as a small style cleanup.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
