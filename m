Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZG0TNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZG0TNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZG0TNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:13:38 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:41340 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZG0TNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:13:38 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 15:13:37 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vXKGsiyLFo2e3PbbyPGtjy5Sq9S3LqKf4Xl19kr9+cI5RTZVO0yb8ZfPZ+Yz2EoRvA
         9CXyvWKjUbvkRxLgsBGBj1ly4WqgdwIB7+j8Ihknql5gsKFoILkW5/hy7/eYaESKcmr2
         c7DhUkogZgPhPf8QDhfxxQ9pSJ5mqiGlnevp0=
MIME-Version: 1.0
In-Reply-To: <52058.1248720339@turing-police.cc.vt.edu>
References: <689eb3470907271102i904d81em6317302e373e0730@mail.gmail.com>
	 <689eb3470907271117x4638464p72964819a80637c0@mail.gmail.com>
	 <52058.1248720339@turing-police.cc.vt.edu>
Date: Mon, 27 Jul 2009 12:07:05 -0700
Message-ID: <689eb3470907271207s23fd313ck92c2448de264ec33@mail.gmail.com>
Subject: Re: Undefined symbol "min_low_pfn"
From: Anupama Chandwani <anupama.chandwani@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure,

On Mon, Jul 27, 2009 at 11:45 AM, <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 27 Jul 2009 11:17:20 PDT, Anupama Chandwani said:
>
>> I want to know what pages (page frame numbers) are used by kernel
>> code/data/bss etc. min_low_pfn would have told me the lowest usable
>> pfn.
>> Is there another way of getting this information? Or printing the min_low_pfn?
>
> What are you trying to do with that number?  Perhaps if you explain the
> problem you're trying to solve by looking at min_low_pfn, somebody will have
> a better solution...
>

I am trying to find the pfns that belong to the kernel image in RAM.
It is a study project to learn the memory management of the linux
kernel, and perhaps suggest a few optimizations.
With min_low_pfn, I can claim that all pfns under it, belong to the
kernel image and hence cannot be used by others.

I have the pfns of other pools, like mapped, mlocked, etc.

Thanks,
Anupama
