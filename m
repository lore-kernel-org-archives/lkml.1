Return-Path: <linux-kernel-owner+w=401wt.eu-S1763030AbXHNCPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763030AbXHNCPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 22:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXHNCPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 22:15:06 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:10249 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXHNCPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 22:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q5b8zHgurqvzpFCBwn0IMdpo4VJncNl/67hkixUi+K/CvmYAmMuCiWCGx+BwkwmsAE8Agd3w0OKYHzq3SydR+sIp2xMBqMPgw3H/a+0BdGryJ0Q56OEf8S22W85NrkLrWuLV4Q14LMuNoRmjgZ7czl4Wq9kgSyIJEYXwWctTlqg=
Message-ID: <1a297b360708131915g2f4fe32ex932631244891643c@mail.gmail.com>
Date: Tue, 14 Aug 2007 06:15:02 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
Cc: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Joe Perches" <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <1187026955.2688.4.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186984174.10249.7.camel@localhost>
	 <200708131933.10125.m.kozlowski@tuxland.pl>
	 <1187026955.2688.4.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, Arjan van de Ven <arjan@infradead.org> wrote:
>
> On Mon, 2007-08-13 at 19:33 +0200, Mariusz Kozlowski wrote:
> > Hello,
> >
> >       I don't recall discusion about this so here are my 3 cents:
> >
> >       I like the idea.
>
> I don't actually. It shows a central MAINTAINERS file is the wrong
> approach; just that 500+ patches to the same file were needed shows
> that.
>
> The maintainer info should be in the source file itself! That's the only
> reasonable way to keep it updated; now I'm all for having it machine
> parsable so that tools can use it, but it still really should be in the
> code itself, not in some central file that will always just go out of
> data, and will be a huge source of needless patch conflicts.


ACK. Very much agree. In fact MAINTAINERS is a wrong thing altogether.

For example, code/drivers under a subsystem, might not be easily add
"able" to a central file in some cases as it is scattered around.

Maintainer info in the source is the right way to go.
