Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYABCCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYABCCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYABCCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:02:11 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:51700 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYABCCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:02:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R0I+W6YA2OXlfOEmCYSx2e9vNWyL/ftCDkdcbPUuDYqmnfAQ9ZtgkL4eLLUAkTD+Z/o+79K9FEKIbg3ozVmoFce9K83L1CCIZsAmO01Dat+QLVIQtX/37w4NnyZ4rcecwFbDUp0/4MPzin6xnIIP3iQgXRO7NEylwGIoh99WvMk=
Message-ID: <9a8748490801011802q7b6bd8e7w38813eb2e5502e50@mail.gmail.com>
Date: Wed, 2 Jan 2008 03:02:09 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Subject: Re: [PATCH] Fix errors detected by checkpatch.pl on nmi_int.c
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080102010549.GA23991@localhost.physics.ucla.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080102010549.GA23991@localhost.physics.ucla.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2008, Carlos R. Mafra <crmafra@gmail.com> wrote:
> This patch fixes most errors detected by checkpatch.pl.
>
>                                      errors   lines of code   errors/KLOC
> arch/x86/oprofile/nmi_int.c (after)       1             461           2.1
> arch/x86/oprofile/nmi_int.c (before)     60             477         125.7
>
> No code changed.
>
> size:
>    text    data     bss     dec     hex filename
>    2675     264     472    3411     d53 nmi_int.o.after
>    2675     264     472    3411     d53 nmi_int.o.before
>
> md5sum:
>   847aea0cc68fe1a2b5e7019439f3b4dd  nmi_int.o.after
>   847aea0cc68fe1a2b5e7019439f3b4dd  nmi_int.o.before
>
> Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
>

Looks good to me (except that an inline patch instead of an attached
one would have been nice ;-)

Kills some trailing whitespace, does some CodingStyle cleanups, is
nicely confined to one file, doesn't (as far as I can tell) change the
way the code works, makes checkpatch less noisy. All good.

Feel free to add
  Reviewed-by: Jesper Juhl <jesper.juhl@gmail.com>
if you like.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
