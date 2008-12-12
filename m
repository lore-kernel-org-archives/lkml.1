Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYLLUje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYLLUje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYLLUjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:39:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50083 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbYLLUjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:39:23 -0500
Message-ID: <4942CBF6.5090105@redhat.com>
Date: Fri, 12 Dec 2008 21:39:18 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>,
       Scott Lurndal <scott.lurndal@3leafsystems.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <20081212152929.GM26095@parisc-linux.org> <494287D4.2070909@redhat.com> <20081212155113.GO26095@parisc-linux.org> <49428AFD.5090009@redhat.com> <20081212182929.GA9631@pendragon.3leafnetworks.com> <20081212190728.GC5774@flint.arm.linux.org.uk> <4942C1D0.1080009@redhat.com> <20081212201239.GE5774@flint.arm.linux.org.uk>
In-Reply-To: <20081212201239.GE5774@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Fri, Dec 12, 2008 at 08:56:00PM +0100, Gerd Hoffmann wrote:
>> Russell King wrote:
>>>> should be similar to pread/pwrite, e.g:
>>>>
>>>>     int preadv(fd, iovec, iovec_size, offset)
>>> Yes, and that's easy for glibc to achieve.
>> This hints the ABI problem exists at syscall level only.  Is that
>> correct?  So we can have
>>
>> 	preadv(fd, vec, vlen, off)
>>
>> argument ordering at app <-> glibc level and
>>
>> 	preadv(fd, vec, off, vlen)
>>
>> ordering at glibc <-> kernel (aka syscall) level and it works fine for
>> ARM + MIPS + PARISC?
> 
> Fine for ARM

Great.  I'll happily switch the ordering then.  /me goes wait for acks
from the other archs and plans for a new patch revision early next week.

thanks,
  Gerd


