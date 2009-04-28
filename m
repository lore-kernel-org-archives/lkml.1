Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZD1JTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZD1JTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZD1JTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:19:00 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:54309 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZD1JS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EEvskQgvSP6/uVZYy5mwLKTNqc+njgBtyKkwxDo0V4ovPkCXGqhTCAwO/OPFOkWfGM
         2bSu+NgMvEOje2ht3BzL1xYzw8B8o+U1xOVPunDGLaAxWN1oiUBRB/Xs+sbK21vz/h6z
         RcXdxcYl4gEHBT0GzpdlnIRvPdNkQ/+/nw8mk=
MIME-Version: 1.0
In-Reply-To: <20090428172845R.fujita.tomonori@lab.ntt.co.jp>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
	 <egHshlwQQFE.A.8CD.mpE9JB@chimera>
	 <20090428172845R.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 28 Apr 2009 14:18:57 +0500
Message-ID: <db2b43030904280218v61fded68rc585ce9c58ba1cce@mail.gmail.com>
Subject: Re: [Bug #13001] PCI-DMA: Out of IOMMU space
From: =?UTF-8?B?0JTQsNC90LjQu9CwINCW0YPQutC+0YbQutC40Lk=?= 
	<optimusgd@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       grundler@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, it is regression. I can reproduce that without allowdac and any
other unnecessary boot options. In later discussion Grant Grundler ask
me apply patch that show 32 bit dma devices in my system. Results I
attached to bugreport. Looks like only one 32 bit dma device in my
system is ata controller, sata-nv. I can stable reproduce IOMMU out of
space when I write data to sata drive.

2009/4/28 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> On Sun, 26 Apr 2009 11:46:28 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.28 and 2.6.29.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13001
>> Subject               : PCI-DMA: Out of IOMMU space
>> Submitter     :  <optimusgd@gmail.com>
>> Date          : 2009-04-03 09:30 (24 days old)
>
> Probably, this is not a regression.
>
> He doesn't hit this problem with 2.6.29 when he uses the kernel boot
> option that he used with 2.6.28. I have no idea how not using
> 'allowdac' can solve the problem though.
>



-- 
С уважением Данила Жукоцкий, системный администратор ЗАО "Роснефтегазмаш"
