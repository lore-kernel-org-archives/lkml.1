Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZCHBET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZCHBET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 20:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZCHBEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 20:04:08 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:53937 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZCHBEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 20:04:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BgG4qgUEc2j9LjfvJLdFZ1LSA7unaeUgV78FdU0TmL7TOkzQbam8mAPb4EBIUKWW6A
         4Qat2h1wXmqCBq8BF18edO/Spwrkythj0INg9is1BFlxhL737GMmY3q33RyKXj56tm6y
         m3sga2OVARsgQK6T6oLpS6d5MJnCRmmrzbr9o=
MIME-Version: 1.0
In-Reply-To: <adaab7wgabs.fsf@cisco.com>
References: <8b67d60903071537p10994257obc7cce99028a740c@mail.gmail.com>
	 <adaab7wgabs.fsf@cisco.com>
Date: Sun, 8 Mar 2009 01:04:03 +0000
Message-ID: <8b67d60903071704j4392cde7mb826531da079430d@mail.gmail.com>
Subject: Re: printk issue - bug?
From: Adrian McMenamin <lkmladrian@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/7 Roland Dreier <rdreier@cisco.com>:

>
> ie offset is a 64-bit type but the printk format for it is %x, which
> presumably only consumes 32 bits on SH4?  Seems like your code is buggy
> and you ignored a compiler warning about printk format mismatch?
>
>  - R.
>

Yes, loff_t is a long long  but why did it work in the first line and
not the second?
