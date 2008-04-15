Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYDOXZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYDOXZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYDOXZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:25:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:51057 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYDOXZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EY43aLIqFfJfvrGWRbv/DIksD3y6NnnkK1aOk/VV/QVfP66TbjPaXCoKJfdos9GJe0NgVcISIOJbOoKTJOyFMQuKpaqlA8RrSKFZoN68Mk2gB//Fiasm0J9Mn7fWi0WIDANB2K//64T392O7DppDwav4TvXpxPvqi+Bhrnvpqjw=
Message-ID: <ed10ee420804151625i1e30abb7r98ddda53ec6e8da6@mail.gmail.com>
Date: Tue, 15 Apr 2008 16:25:29 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: gart: factor out common code
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080415104357.GA13441@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080415104357.GA13441@elf.ucw.cz>
X-Google-Sender-Auth: 61b319c3301c18ee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/08, Pavel Machek <pavel@ucw.cz> wrote:
> Cleanup gart handling on amd64 a bit: move common code into
>  enable_gart_translation , and use symbolic register names where
>  appropriate.
>
>  Signed-off-by: Pavel Machek <pavel@suse.cz>

Which source tree is this patch against?  I'm looking at Linus
latest and I don't see the AMD64_* constants defined in the
same place.

Other reviewer comments:
The casting between struct pci_dev * and u64 is kind of ugly,
I presume the reason for the narrowing casts in the block of
code you moved is documented somewhere.

It looks OK as far as I can see, but I'm not looking at the same
source code, so I don't think I should add a Reviewed-by:.

-sb
