Return-Path: <linux-kernel-owner+w=401wt.eu-S1765223AbXE2Txo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765223AbXE2Txo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759597AbXE2Txg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:53:36 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:8260 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913AbXE2Txf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t5zPDbDN/nkgn9jsSqP2XmSegyJI9PrzHP0Gko6exF0WheWpcrUXIYcLL2XKKzRjFpmmcGw6KnMihqj22OLJi4RwW2aWPtvWNsLDoHm9igoaaHfEDkG7R0SybsJrRhzlsHi2+XIoUtm/8/CNP0UDukog6Z72qBPJO7PgZSONipw=
Message-ID: <5486cca80705291253vb793caqd632f3adbb2479ad@mail.gmail.com>
Date: Tue, 29 May 2007 21:53:33 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: [ck] 2.6.22-rc3-ck1
Cc: "ck list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705270800.06612.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705270800.06612.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2007/5/27, Con Kolivas <kernel@kolivas.org>:
> New test release:
>
> http://ck.kolivas.org/patches/pre-releases/2.6.22-rc3/2.6.22-rc3-ck1/
>
> This is a resync with newer -rc and contains the updated swap prefetch code.

With this patch there is a stunning difference with the no swap
prefetch case on my system. With previous  SP the difference was
around 2 seconds, now is more than 7 seconds.

Swap Prefetch OFF
# ./sp_tester
Ram 776388000  Swap 514040000
Total ram to be malloced: 1033408000 bytes
Starting first malloc of 516704000 bytes
Starting 1st read of first malloc
Touching this much ram takes 1642 milliseconds
Starting second malloc of 516704000 bytes
Completed second malloc and free
Sleeping for 60 seconds
Important part - starting reread of first malloc
Completed read of first malloc
Timed portion 9089 milliseconds


Swap Prefetch OFF
# ./sp_tester
Ram 776388000  Swap 514040000
Total ram to be malloced: 1033408000 bytes
Starting first malloc of 516704000 bytes
Starting 1st read of first malloc
Touching this much ram takes 1635 milliseconds
Starting second malloc of 516704000 bytes
Completed second malloc and free
Sleeping for 60 seconds
Important part - starting reread of first malloc
Completed read of first malloc
Timed portion 1783 milliseconds


Regards,

    ~  Antonio
