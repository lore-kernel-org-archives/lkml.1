Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZFEVld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZFEVld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZFEVlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:41:25 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60779 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZFEVlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gyl4/BO0WUpB3eiXoMtZrlQWYvd7OimQhstWkWsORH8vvlz8QcmsFLf3Iun/x/Aj24
         Lp2aPlfj/fvygDxXVZObXonc2ySCf+XTvSTX8AFPwl8OfT0zNjMd/LtzdSLpxATruqUS
         nDZ7tuNQQpxWzuRPfkxsDrjduvPn1VlPLgHXc=
Message-ID: <4A299151.3040109@tuffmail.co.uk>
Date: Fri, 05 Jun 2009 22:42:41 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Eric Sandeen <sandeen@redhat.com>, Aioanei Rares <krnl.list@gmail.com>,
       linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> 	<4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com> 	<4A294B15.9070209@tuffmail.co.uk> <ac3eb2510906050951o200c3aeex56dcb32bf29d0607@mail.gmail.com>
In-Reply-To: <ac3eb2510906050951o200c3aeex56dcb32bf29d0607@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Fri, Jun 5, 2009 at 18:43, Alan Jenkins<alan-jenkins@tuffmail.co.uk> wrote:
>
>   
>> If I remove the corrupted file and copy a "known good" copy into it's place,
>> then the corruption doesn't happen.  I've verified this a couple of times.
>>  The corruption only occurs if the file was created by "locale-gen".
>>     
>
> Does it use things like: fallocate()?
>
> Kay
>   

Not quite. Ted says it's already reported as

    http://bugzilla.kernel.org/show_bug.cgi?id=13292

It includes an strace log which implicates the use of both mmap() and 
write() on the same file.  Sounds scary :-).

Alan
