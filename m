Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYBIQq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYBIQq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbYBIQqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:46:13 -0500
Received: from qb-out-0506.google.com ([72.14.204.238]:62435 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYBIQqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:46:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gpa4Ioxrzp/wRFqB7trS0tmXCPgzAN+F8tCUNeRd8fJeXXBwmL4EVdPlV5Qk7IbTIKCVIP/KC6wgkekbkTsW9EhF4SEZUgh9/CnTescRZOxd+Ygn1+SD2y9zmJ3SFquuYMpAKYlf/972ByFyz3Bxlpe+5o4wZnCsGFzBIhIwOVU=
Message-ID: <2f11576a0802090846t7655e988pb1b712696cad1098@mail.gmail.com>
Date: Sun, 10 Feb 2008 01:46:06 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Jon Masters" <jonathan@jonmasters.org>
Subject: Re: [sample] mem_notify v6: usage example
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Marcelo Tosatti" <marcelo@kvack.org>,
       "Daniel Spang" <daniel.spang@gmail.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Al Boldi" <a1426z@gawab.com>,
       "Zan Lynx" <zlynx@acm.org>
In-Reply-To: <CE520A17-98F2-4A08-82AB-C3D5061616A1@jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2f11576a0802090755n123c9b7dh26e0af6a2fef28af@mail.gmail.com>
	 <CE520A17-98F2-4A08-82AB-C3D5061616A1@jonmasters.org>
X-Google-Sender-Auth: bfee63bdb5ab5ebe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon

> This really needs to be triggered via a generic kernel event in the
> final version - I picture glibc having a reservation API and having
> generic support for freeing such reservations.

to be honest, I doubt idea of generic reservation framework.

end up, we hope drop the application cache, not also dataless memory.
but, automatically drop mechanism only able to drop dataless memory.

and, many application have own memory management subsystem.
I afraid to nobody use too complex framework.

What do you think it?
I hope see your API. please post it.

Thanks!
