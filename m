Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0CKT53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:57:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab0CKT51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:57:27 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru>
	<x497hpm8p69.fsf@segfault.boston.devel.redhat.com>
	<4B957122.4060007@msgid.tls.msk.ru>
	<x49mxyi78ob.fsf@segfault.boston.devel.redhat.com>
	<4B957AF3.6040801@msgid.tls.msk.ru>
	<4B957D20.4010904@msgid.tls.msk.ru>
	<x49wrxij11s.fsf@segfault.boston.devel.redhat.com>
	<4B994022.6030703@msgid.tls.msk.ru>
	<4B994888.8020007@msgid.tls.msk.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 11 Mar 2010 14:57:22 -0500
In-Reply-To: <4B994888.8020007@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Thu, 11 Mar 2010 22:46:16 +0300")
Message-ID: <x49eijqiqcd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> Michael Tokarev ?????:
>> Jeff Moyer wrote:
>> []
>>> Yeah, whoops.  I built the libaio test harness using -m32 and this patch
>>> works for me.  Would you mind giving it a try?
>> 
>> It appears to work here so far.  I did not run massive i/o test suite
>> but it now passes basic multiple kernel unpacking in parallel tests
>> (before it didnt' even recognize the partition table).
>> 
>> So the patch - at least basically - works.
>
> It looks like the conclusion was preliminary a bit.
> I tested the wrong kvm binary which does not have
> aio support...
>
> And when running real thing it crashes.   I tested it
> on 2.6.32 (trivial corrections to the patch required).

Could you just post your version of the patch so I can have a look?

Thanks,
Jeff
