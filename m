Return-Path: <linux-kernel-owner+w=401wt.eu-S1751047AbXCBViR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047AbXCBViR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbXCBViR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:38:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:64096 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbXCBViQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:38:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KQM9pUBPy6NtRW3fhxFotjksiXaOBmskR2X5yfH1RxvLEPjcYZ08DL784+S2UsEQVtxFW7T4nE2+grpUT37Q9oZsVEb0CyTMj3bWZ+poTnXaZ1GFv7Uvb5WatMVe2UN7p2Q68KMq7sduDSSedVDlUwP9ZFHlTB1AIgSJyuAHgdQ=
Message-ID: <29495f1d0703021338k41bad9d3teaf93c8abcbfc152@mail.gmail.com>
Date: Fri, 2 Mar 2007 13:38:15 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Alexander Y. Fomichev" <gluk@php4.ru>
Subject: Re: kernel BUG at arch/x86_64/mm/../../i386/mm/hugetlbpage.c:140!
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       admin@list.net.ru
In-Reply-To: <200703021651.16050.gluk@php4.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703021651.16050.gluk@php4.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/2/07, Alexander Y. Fomichev <gluk@php4.ru> wrote:
> G'day
>
> I'm hit a bug on 2.6.21-rc1 at startup of mysql with 'large-pages' flag set.
> (at this point mysql trying to allocate pages from hugetlb pool by sysv
> shm syscalls). Seems like it could be triggered by previous badness
> and probably hugetlb itself is not related. Anyway i couldn't reproduce
> it by now with 2.6.21-rc2 git commit 562aa1d4c6a874373f9a48ac184f662fbbb06a04.
> Very likely it has been fixed somwhere between 2.6.21-rc1 and -rc2,
> but i couldn't find something related by git log so any comments are welcome.

Adam Litke posted a bug fix for hugetlb shm: http://lkml.org/lkml/2007/3/1/381.

Does that help fix your problem too?

Thanks,
Nish
