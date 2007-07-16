Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbXGPVPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbXGPVPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbXGPVPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:15:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:34165 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933AbXGPVPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qhcv0vvnne94tgOf3AHddYYl8fEOyqdu+68L37JJou8x9Py+Ko4RyuKMualFIbTrhOlJwK6CPmj8eh5+EpZbY9ezmWdCBdBhcx12/0o/K4sQkE8FtNj9rs12/W0qHUbrjdP8gEt1NLzpzMhRsc9RESS9RopTRHeOFXpRwxigJzA=
Message-ID: <9a8748490707161415q621fe636pe9dab3a49e46c3d1@mail.gmail.com>
Date: Mon, 16 Jul 2007 23:15:11 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: - isapnp-remove-pointless-check-of-type-against-0-in-isapnp_read_tag.patch removed from -mm tree
Cc: mm-commits@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200707162059.l6GKxPee002427@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707162059.l6GKxPee002427@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>
> The patch titled
>      isapnp: remove pointless check of 'type' against 0 in isapnp_read_tag()
> has been removed from the -mm tree.  Its filename was
>      isapnp-remove-pointless-check-of-type-against-0-in-isapnp_read_tag.patch
>
> This patch was dropped because it was merged into mainline or a subsystem tree
>
> ------------------------------------------------------
> Subject: isapnp: remove pointless check of 'type' against 0 in isapnp_read_tag()
> From: Jesper Juhl <jesper.juhl@gmail.com>
>
> In drivers/pnp/isapnp/core.c::isapnp_read_tag() there is a test of 'type'
> being == 0 a bit down in the function.  That test doesn't make any sense.
> If 'type' could indeed be NULL, then the test happens way too late as we'd
> already have tried to dereference the pointer earlier and looking at the
> callers it also turns out that there is no way type can ever actually be
> NULL.
>
> So the test is completely pointless and should just be removed.
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I should have included this in the patch changelog, but I forgot.
Credit should be given where credit is due, even for small stuff like
this. So, for the record:
Thanks go to Andrew Morton for pointing out errors in my initial patch
and pointing me at the fact that callers never actually cause a null
'type' - thank you Andrew for your always careful review of even the
most simple of patches.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
