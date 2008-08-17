Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYHQT0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYHQT0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbYHQT0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:26:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:6886 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbYHQT0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CcyMMNX7qiTfv1Cd1RQLr3t+3jgpDf2g8oWEMDNC07RysbneCY9ohtdpN4YV4jxq1b
         xl2JRjo8bhBzFku4fmsHjyX8gt8cjpYJzP3r5V0nMFrMoOJ2eYINoIxGLw5bLz05E1v5
         za3xAx8qRdxyv9AaOvQD34o4qfX8gd8P9+EJY=
Message-ID: <f2b895370808171226l13728b1dg7e79051c158e21f3@mail.gmail.com>
Date: Sun, 17 Aug 2008 21:26:07 +0200
From: "Marc Villemade" <mastachand@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [Follow-up] Physical memory disappeared from /proc/meminfo
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080817145906.06ccd795@riellaptop.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b895370808171059x4bd0296frf50b07ae7af21375@mail.gmail.com>
	 <20080817145906.06ccd795@riellaptop.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hey

Thanks for your answer, but it still doesn't come close. I'm up to 1.5
Gig adding what i said. and PageTables + VMallocTotal equals 160 Mo.
Sounds unlikely to me that something unaccounted for might go up to
1.4 Gig, don't you think ? Or maybe it is accounted somewhere else
than /proc/meminfo ? Please point me to the right place if so.

Cheers

Marc Villemade


On Sun, Aug 17, 2008 at 8:59 PM, Rik van Riel <riel@redhat.com> wrote:
> On Sun, 17 Aug 2008 19:59:10 +0200
> "Marc Villemade" <mastachand@gmail.com> wrote:
>
>> I'm having exactly the same issue but on a 2.6.20.4 vanilla kernel
>> (x86). /proc/meminfo shows that
>> MemFree+Buffers+cached+AnonPages+Slab+Mapped != MemTotal, which AFAIK
>> should be the case.
>
> There are also page tables, vmalloc memory and various
> unaccounted kernel allocations.
>
> --
> All rights reversed.
>
