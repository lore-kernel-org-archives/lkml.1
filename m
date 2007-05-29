Return-Path: <linux-kernel-owner+w=401wt.eu-S1765489AbXE2T74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765489AbXE2T74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765407AbXE2T7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:59:43 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:17747 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765382AbXE2T7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SQQ9K5OWxvXQHOudEacc4YvEBypu0UKWd7z/E+maKjjZLu1k6W9LQGDFwlFYoUSAQ258s1syDx6JvTtRQr1qHUUmffNQZHp+61FiM25HCH2cDGYeyoUpSXzYVhg4lpPbIBC7LM4liExLgW2Qt/sve/6ksI5I8YPBbWbQW59Uq7k=
Message-ID: <5486cca80705291259s63edf2bcv7035f700aa23e8b1@mail.gmail.com>
Date: Tue, 29 May 2007 21:59:34 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: [ck] 2.6.22-rc3-ck1
Cc: "ck list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <5486cca80705291253vb793caqd632f3adbb2479ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705270800.06612.kernel@kolivas.org>
	 <5486cca80705291253vb793caqd632f3adbb2479ad@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/29, Antonino Ingargiola <tritemio@gmail.com>:
[cut]
> Swap Prefetch OFF
> # ./sp_tester
> Ram 776388000  Swap 514040000
> Total ram to be malloced: 1033408000 bytes
> Starting first malloc of 516704000 bytes
> Starting 1st read of first malloc
> Touching this much ram takes 1642 milliseconds
> Starting second malloc of 516704000 bytes
> Completed second malloc and free
> Sleeping for 60 seconds
> Important part - starting reread of first malloc
> Completed read of first malloc
> Timed portion 9089 milliseconds
>
>
> Swap Prefetch OFF
> # ./sp_tester
> Ram 776388000  Swap 514040000
> Total ram to be malloced: 1033408000 bytes
> Starting first malloc of 516704000 bytes
> Starting 1st read of first malloc
> Touching this much ram takes 1635 milliseconds
> Starting second malloc of 516704000 bytes
> Completed second malloc and free
> Sleeping for 60 seconds
> Important part - starting reread of first malloc
> Completed read of first malloc
> Timed portion 1783 milliseconds

The second case is clearly with swap prefetch *ON*, sorry.


     ~  Antonio
