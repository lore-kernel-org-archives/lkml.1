Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbXLJBHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbXLJBHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 20:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXLJBHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 20:07:31 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:24627 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbXLJBHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 20:07:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jCpfhNXFBE0FjZD7IF+eo1T9YY5XfM0bh2F+a0XaUOqbKHF3UKCN3RFpv3uJVf1TQkYQGzZNrHL+Zfzs0d9LUmTYUwTR+GeUFR9LjKF89JfSDY2GzxqVFs/9igqFWYDwHEFucr+HkVt/sCsAYsiw+laDNDZJ6cwnMliK7crUJvU=
Message-ID: <a8e1da0712091707ve2edf0el7103b66ae28b58@mail.gmail.com>
Date: Mon, 10 Dec 2007 09:07:27 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Subject: Re: 2.6.24-rc4-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, mickflemm@gmail.com,
       linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <43e72e890712071422j34ca2338xf98fda661f3c22fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <20071207021258.GA12624@darkstar.lan>
	 <43e72e890712071422j34ca2338xf98fda661f3c22fc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 8, 2007 6:22 AM, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu> wrote:
> On Dec 6, 2007 9:12 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > Hi,
> >
> > 2.6.24-rc4-mm1 build failed at drivers/net/wireless/ath5k/base.c for some inline functions like this:
> > drivers/net/wireless/ath5k/base.c:292: sorry, unimplemented: inlining failed in call to 'ath5k_extend_tsf': function body not available
> >
> > fix it with adjust the order of inline function body.
> >
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

Thanks.

>
> Thanks Dave. What version of gcc were you using? I haven't run into this.

gcc 3.4.6

>
> BTW, nothing new was added in this patch, things were just shifted,
> but even that may be copyrightable. Is it fair to assume you are
> licensing these changes under the same license the file is in?

Ok, I don't care.

>
> For this file we'd usually use:
>
> Changes-licensed-under: 3-clause-BSD
>
> For future reference:
>
> http://linuxwireless.org/en/developers/Documentation/SubmittingPatches#Changes-licensed-undertag
>
>   Luis
>
