Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbXKEOCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbXKEOCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXKEOCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:02:46 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:29906 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXKEOCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:02:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UlnQpnnZtUrz5dMw/xuHrjEyhmfxTLwvqx7KWgI8YhpbpghpKS1tir7Dn4OVJQCattsFsO+uOrY3IajmytAUyRm2aLXpL/JNwtJBbcdjioXNJaZA9o0aQh2coauxFYYACOQNqiVgdfqB9t2cN8V4XUs4dNlT4fYZ9pk8OI/JXR8=
Message-ID: <472F2281.2040507@gmail.com>
Date: Mon, 05 Nov 2007 15:02:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Felipe Dias <felipediassss@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: textsearch in module = BUG: scheduling while atomic
References: <3c16e8dc0711040915n206c38d6u7e15972bf55e0e0d@mail.gmail.com>	 <472E07ED.2010907@gmail.com>	 <3c16e8dc0711041222w6bc67b3fn8320e982ffd723b0@mail.gmail.com>	 <472E346E.90309@gmail.com>	 <3c16e8dc0711041405m33c5e54dw6c8d51ac600d51cf@mail.gmail.com>	 <472E44CA.6090600@gmail.com> <472E458B.50903@gmail.com> <3c16e8dc0711041457r684fb42fpc3845a941162b65d@mail.gmail.com>
In-Reply-To: <3c16e8dc0711041457r684fb42fpc3845a941162b65d@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2007 11:57 PM, Felipe Dias wrote:
> I change the algo, from "bm" to "kmp" and probably resolve. I will
> make more tests and if error occour i post latter...

Anyway, you should do what I suggested before -- pass 0 instead of TS_AUTOLOAD.
If somebody doesn't have kmp module loaded it will spit out the warnings again,
because the kernel will try to load it (and it's not atomic operation).

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
