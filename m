Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZBJNfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZBJNfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZBJNfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:35:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:58312 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZBJNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Qws4ty3jDYR+fkd3ERv2gbhILyFgvF21qix0gz/oo60Ptwe/ZI5HlwI9WMygVV2yTt
         ph8LZsSKasJotQyaIagFisF+mGAtvJYRltaQKzbOPOP0yxnDldVVRSVdCs3gXdFjBIu1
         0w8qtHViXFiPo00NOPGFX6OvKcCb9RLhyqIwo=
MIME-Version: 1.0
In-Reply-To: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
Date: Tue, 10 Feb 2009 15:35:03 +0200
X-Google-Sender-Auth: f8a4ae448909e3b2
Message-ID: <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
Subject: Re: [PATCH] Export symbol ksize()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-crypto@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 3:21 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> It needed for crypto.ko
>
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

That's bit terse for a changelog. I did a quick grep but wasn't able
to find the offending call-site. Where is it?

We unexported ksize() because it's a problematic interface and you
almost certainly want to use the alternatives (e.g. krealloc). I think
I need bit more convincing to apply this patch...

                        Pekka
