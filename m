Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYGVOqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYGVOqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYGVOqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:46:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:56090 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYGVOqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AcpCUAmLfpcQfx487M/3j4SYtguFjl3lpcYxi42U9yl4F639Hhozc3TJ8lBthTgbGN
         sWbVW7Mt++8V1a9T00B5Q4BYmMUjKmOmUNzRgvnTzp4BnBpu9w3DCuOc3jk4AyhgBG+W
         /6wO2aIE/pUkIUM0af0o9EK+9sK2VcjS0ZuoY=
Message-ID: <cfd18e0f0807220746k41ff209bgc099a83042e38086@mail.gmail.com>
Date: Tue, 22 Jul 2008 16:46:41 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm] coredump: format_corename: don't append .%pid if multi-threaded
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Roland McGrath" <roland@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, andi@firstfloor.org
In-Reply-To: <20080722130206.GA3297@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807210137.m6L1bN0H011138@imap1.linux-foundation.org>
	 <20080721102940.666d733d@the-village.bc.nu>
	 <20080721210121.C5E741541A5@magilla.localdomain>
	 <20080721221416.6d4f9014@lxorguk.ukuu.org.uk>
	 <20080722113731.GA1383@tv-sign.ru> <20080722121824.GB1383@tv-sign.ru>
	 <cfd18e0f0807220521x5faea19bn1f545b23b84ead6a@mail.gmail.com>
	 <20080722124314.GA3267@tv-sign.ru>
	 <cfd18e0f0807220547w691346ecyd4819fa4b7c23325@mail.gmail.com>
	 <20080722130206.GA3297@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 3:02 PM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> On 07/22, Michael Kerrisk wrote:
>>
>> On Tue, Jul 22, 2008 at 2:43 PM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
>> >
>> > That said, this is the user-visible change...
>>
>> True.  Not sure how important that is in this case though.  What is
>> the reason for making this change (other than tidiness)?
>
> Tidiness is the only reason.
>
> Please don't hesitate to nack this patch if you think we shouldn't
> change the historical behaviour, the cleanup is very minor.

It is hard to think of something that might break because of this, so
I'll remain silent.

> As for me, I think it is a bit strange we append "%.pid" depending on
> is_multithreaded, the same app can have 1 or more threads for various

Agreed.  It is strange.

Cheers,

Michael

> reasons when the coredump happens, but this behaviour is very old and
> perhaps it is too late to change.
>
> Oleg.
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
