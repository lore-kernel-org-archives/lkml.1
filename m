Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZIOSAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZIOSAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbZIOSA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:00:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:32161 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZIOSA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Zv689kh1NEIAMfdNZn9JoPkZzH5UctVttSRD9mmOYnHctaGcs2V+5JTAyMNVb2tIaI
         /ddHW/6g/CcPf2beUtWR1DhzrC8q6zhVxPqF4I8pRqk6M5J6NoU7X8H3KQc+WPbABfk7
         p8XWbcQ/b0rq6PqCV+cBno53th8E5gEIJWvoE=
MIME-Version: 1.0
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501F100E4@exchange.ZeugmaSystems.local>
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0FF17@exchange.ZeugmaSystems.local>
	 <200909151127.10697.bjorn.helgaas@hp.com>
	 <DDFD17CC94A9BD49A82147DDF7D545C501F100E4@exchange.ZeugmaSystems.local>
Date: Tue, 15 Sep 2009 11:00:29 -0700
X-Google-Sender-Auth: aa753a367cc8d1d1
Message-ID: <12c511ca0909151100ne3841b7l7af5bffb977d6d9b@mail.gmail.com>
Subject: Re: [PATCH] cleanup legacy console_print function
From: Tony Luck <tony.luck@intel.com>
To: Anirban Sinha <ASinha@zeugmasystems.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/arch/ia64/kernel/head.h
> +++ b/arch/ia64/kernel/head.h
> @@ -1 +1,3 @@
> +#ifndef __ASSEMBLY__
>  extern void console_print(const char *s);
> +#endif

Umm.  Your new file "head.h" is only included by head.S ... perhaps it would be
better to delete head.h entirely and drop the #include from head.S?

-Tony
