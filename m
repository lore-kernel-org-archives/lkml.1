Return-Path: <linux-kernel-owner+w=401wt.eu-S1763586AbYD0Vga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763586AbYD0Vga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 17:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYD0VgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 17:36:22 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:59556 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYD0VgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 17:36:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CjL6LS0U41NIJ860rtJzqno98AeyqkCwqDuL+prxwglhnj4DYehMPYQ3KPzXOMSOloWJZaVK8m45p6Az0JklK59NhGWGzg8jFcgAnOkcfARg5LnpqvMFv9jRQcgM+GbMcQFcXaW5Y7QY3H9l4/vrHA6EOu8MrET5g3byU29c0PY=
Message-ID: <9a8748490804271435r21743bd1n836f0bd8347bd89@mail.gmail.com>
Date: Sun, 27 Apr 2008 23:35:50 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH][Resend] PCI Express ASPM support should default to 'No'
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Shaohua Li" <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
       trivial@kernel.org
In-Reply-To: <200804271424.56188.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0804272159520.2352@dragon.funnycrock.com>
	 <200804271424.56188.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/27 Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Sunday, April 27, 2008 1:07 pm Jesper Juhl wrote:
>  > From: Jesper Juhl <jesper.juhl@gmail.com>
>  >
>  > [This patch was previously submitted  23 April 2008 00:28]
>  >
>  > Andrew; if you could merge this in -mm it would be good, otherwise I'll
>  > just queue it up in the trivial tree for the next merge window.
>  >
>  >
>  > Running 'make oldconfig' I just noticed that PCIEASPM defaults to
>  > 'y' in Kconfig even though the feature is experimental and the
>  > help text recommends that if you are unsure you say 'n'.
>  > It seems to me that this really should default to 'n', not 'y'.
>  > The following patch makes that change. Please consider merging.
>  >
>  > Jesse Barnes commented on the patch that it "Seem reasonable".
>  > Shaohua Li also commented saying "Ok, I'm fine with the patch."
>  >
>  > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>
>  I already merged this into the PCI tree, I'll be sending the pull request
>  soon.
>
Ok, thanks :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
