Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbYBYMLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbYBYMLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 07:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYBYMLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 07:11:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:44764 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbYBYMLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:11:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dyVYREO7TI86eTeWejoWyEnd5hsWAaGAbj7bEoj0AT9UNtoCzOHNc8vQrQWLE83UoWXOhtlUKRlM1Ja71QY/htXLBQasXq8NkZf9HKB0mjS7NZ6kCRx4ESeOgqoJ/fNIRSpPu8ve6mGBgpDebDE+MUCjjEbAoO7E8IiALHqLj8g=
Message-ID: <84144f020802250411i7a4a7c51h60ed9f9878c86422@mail.gmail.com>
Date: Mon, 25 Feb 2008 14:11:04 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Greg KH" <greg@kroah.com>, "Alexey Zaytsev" <alexey.zaytsev@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200802251054.57070.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru>
	 <Pine.LNX.4.64.0802250814450.10065@sbz-30.cs.Helsinki.FI>
	 <20080225064935.GA20997@kroah.com> <200802251054.57070.mb@bu3sch.de>
X-Google-Sender-Auth: 7fdf968cbea22c80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:54 AM, Michael Buesch <mb@bu3sch.de> wrote:
>  > Isn't the resolution Michael is suggesting is, "use the different driver"?
>
>  I have two resolutions. One being:
>  rmmod b44
>  rmmod ssb
>  modprobe bcm43xx
>  modprobe b44
>
>  The other being: Wait for 2.6.25 and use the maintained b43 driver.

Neither of which seem like acceptable solutions for a 2.6.23 -> 2.6.24
_regression_. Or maybe I am just too naive to believe Linus' statement
on not letting the kernel regress...
