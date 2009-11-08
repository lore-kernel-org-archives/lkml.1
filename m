Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZKHPtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZKHPtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZKHPtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:49:32 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:61912 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZKHPtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:49:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mys6ywa9oWuetHof8V8c9OvpRVUtsKqxGUdSB/lLG5ac6m3Rjq5JBr/6b6un+pYyIF
         XD6z3yu7twjpKWMLdIjZu/HzmcFEjeDJ3vAhGBn6w5I6xrlqeyRFLYJR48+Qagom1Ook
         kbkLu9Y53REFTSZxcquW33JziZJnTiIH5lRZg=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0911081630180.26458@obet.zrqbmnf.qr>
References: <cover.1257602781.git.andre.goddard@gmail.com> 
	<643e6260a571b533d8985b377a82410aded4ddae.1257602781.git.andre.goddard@gmail.com> 
	<alpine.LSU.2.00.0911081630180.26458@obet.zrqbmnf.qr>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 8 Nov 2009 13:49:17 -0200
Message-ID: <b8bf37780911080749h578d3a03ve7e08d606b71feca@mail.gmail.com>
Subject: Re: [PATCH v4 01/12] vsprintf: factorize "(null)" string
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 1:37 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> Stripping the humongous Cc list for sanity.
>
>
> On Saturday 2009-11-07 16:16, André Goddard Rosa wrote:
>
>>Change "<NULL>" to "(null)" and make it a static const char[] hoping that
>>the compiler will make null_str a label to a read-only area containing it.
>
> Hoping? Nah, thanks.

:) That's just because I don't always trust gcc blindly. :)

>>See:
>>http://udrepper.livejournal.com/13851.html
>
> Ulrich's example already _has_ a variable that is then changed from
> const char * to const char[]. Of course doing that will save you the
> extra pointer.
> But vsprintf.c on the other hand did not have that extra variable to
> begin with!

Correct, of course! Most relevant reference is the first one:
http://people.redhat.com/drepper/dsohowto.pdf part 2.4.2

The others are just related/akin to the topic; interesting nevertheless.

> But it is ok nevertheless, and the unification of <NULL> vs
> (null) is worthwhile.

Thanks,
André
