Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZJPKn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZJPKn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZJPKn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:43:58 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:33142 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZJPKn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EyK5gybDF6cNb8G3j5JFjOtOycww8HZHPA/DQeAj5Z5QUfKJuZ/NycQBf9Nd5QOiS0
         uSSICkUUao3uFU4VVuiYm3yqErw7Xti0+PJ6ZkAFCS7mJuHsDEcP9rEpk24yCfo0u4iM
         PwxLdNFZSRjlX6v2yME8aAkQRHojzX9V03c8A=
MIME-Version: 1.0
In-Reply-To: <20091016092418.GA3686@linux-mips.org>
References: <20091016141719.de606482.minchan.kim@barrios-desktop>
	 <20091016092418.GA3686@linux-mips.org>
Date: Fri, 16 Oct 2009 19:43:20 +0900
Message-ID: <28c262360910160343m1cf8bbf3g527085f29e0ae868@mail.gmail.com>
Subject: Re: BUG? linux-mips flush_dcache_page
From: Minchan Kim <minchan.kim@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, lkml <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Chungki woo <chungki.woo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 6:24 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Fri, Oct 16, 2009 at 02:17:19PM +0900, Minchan Kim wrote:
>
>> Many code of kernel fs usually allocate high page and flush.
>> But flush_dcache_page of mips checks PageHighMem to avoid flush
>> so that data consistency is broken, I think.
>
> What processor and cache configuration?

Chungki. Could you anwer this question ?

>> I found it's by you and Atsushi-san on 585fa724.
>> Why do we need the check?
>> Could you elaborte please?
>
> The if statement exists because __flush_dcache_page would crash if a page
> is not mapped.  This of course isn't correct but that wasn't a problem
> since highmem still is only supported on machines that don't have aliases.

Thansk for good explanation.
Chungki. Please let us know your machine(processor and cache configuration)

>
>  Ralf
>



-- 
Kind regards,
Minchan Kim
