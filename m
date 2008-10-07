Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYJGQbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYJGQbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYJGQbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:31:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:25427 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYJGQbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=D/cwsIe/NX643ubHOvOsxIFW1LCNrxF9E7Ri2/ZMk86x5Zngwoe5zBQbhatgoFdd56
         6QEGfIii1malY/v5xRu9afe2HJ//AlULvOEoHW7yT5HA0E3EInig5zTbNuyXoFM+HqRu
         cAaZE762uAYzPPQNOO5VqCDmDrpJp3NNDBBWk=
Message-ID: <2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com>
Date: Wed, 8 Oct 2008 01:31:05 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@redhat.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
X-Google-Sender-Auth: 02cb040d742b99b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If SHM_MAP_NOT_FIXED specified and shmaddr is not NULL, then the kernel takes
> shmaddr as a hint about where to place the mapping. The address of the mapping
> is returned as the result of the call.
>
> It's similar to mmap() without MAP_FIXED.

ummm

Sorry, no.
This description still doesn't explain why this interface is needed.

The one of the points is this interface is used by another person or not.
You should explain how large this interface benefit has.

Andi kleen explained this interface _can_  be used another one.
but nobody explain who use it actually.
