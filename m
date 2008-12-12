Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbYLLT4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbYLLT4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYLLT4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:56:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50541 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYLLT4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:56:06 -0500
Message-ID: <4942C1D0.1080009@redhat.com>
Date: Fri, 12 Dec 2008 20:56:00 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Scott Lurndal <scott.lurndal@3leafsystems.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <20081212152929.GM26095@parisc-linux.org> <494287D4.2070909@redhat.com> <20081212155113.GO26095@parisc-linux.org> <49428AFD.5090009@redhat.com> <20081212182929.GA9631@pendragon.3leafnetworks.com> <20081212190728.GC5774@flint.arm.linux.org.uk>
In-Reply-To: <20081212190728.GC5774@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
>> should be similar to pread/pwrite, e.g:
>>
>>     int preadv(fd, iovec, iovec_size, offset)
> 
> Yes, and that's easy for glibc to achieve.

This hints the ABI problem exists at syscall level only.  Is that
correct?  So we can have

	preadv(fd, vec, vlen, off)

argument ordering at app <-> glibc level and

	preadv(fd, vec, off, vlen)

ordering at glibc <-> kernel (aka syscall) level and it works fine for
ARM + MIPS + PARISC?

thanks,
  Gerd


