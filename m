Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbXGQI7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbXGQI7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760867AbXGQI7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:59:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:12362 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759693AbXGQI7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NPvezuRKlwxzykgjgWY7va3fS6yV94awSUHJ+BOJyo1D6+KC3UquIL6gLPF2uXQWsFTXK0nlWGH1DXIDmaWKPg/Gth3KsjdSV/633CBRbLPcKF05oH2ywx1XP36xDpPN8q8Ub3/TJ4ymBy3+gqIPJWtubUP60kgwo0vD4jaCHHE=
Message-ID: <84144f020707170159x734ea536hef214c36ef0a1769@mail.gmail.com>
Date: Tue, 17 Jul 2007 11:59:10 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: uninline check_signature()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, geert@linux-m68k.org,
       zippel@linux-m68k.org, jdike@karaya.com, alan@lxorguk.ukuu.org.uk,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>
In-Reply-To: <20070716221257.GA12230@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
	 <20070716221257.GA12230@osiris.ibm.com>
X-Google-Sender-Auth: c151af9255a68eee
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On 7/17/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> Hmm.. this breaks s390 and probably m68k and UML as well:
>
>   CC      lib/check_signature.o
> lib/check_signature.c: In function 'check_signature':
> lib/check_signature.c:19: error: implicit declaration of function 'readb'

Just to confirm: it breaks UML too.
