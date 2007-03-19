Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbXCSTkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbXCSTkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbXCSTkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:40:14 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39350 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbXCSTkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:40:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Avi Kivity <avi@argo.co.il>, David Miller <davem@davemloft.net>,
       dmlb2000@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE Availability Inconsistency
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
	<20070305.160303.59493440.davem@davemloft.net>
	<9c21eeae0703051604l20a029c3r8cf09d792ba523be@mail.gmail.com>
	<20070305.162620.04006691.davem@davemloft.net>
	<45ECD03F.2040008@zytor.com> <45F07B63.1000105@argo.co.il>
	<45F08C60.6010404@zytor.com>
Date: Mon, 19 Mar 2007 13:39:29 -0600
In-Reply-To: <45F08C60.6010404@zytor.com> (H. Peter Anvin's message of "Thu,
	08 Mar 2007 14:21:20 -0800")
Message-ID: <m1slc1vx8u.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Avi Kivity wrote:
>>>
>>> It definitely should, especially on x86-64, where the page size isn't
>>> guaranteed by the ABI (on i386, the ABI guarantees a 4K page size; on x86-64
>>> it can be up to 64K.)
>>
>> Wouldn't that be ia64?
>
> No, the x86-64 EFI ABI permits page sizes up to 64K.  Currently, of course, the
> only page size in use is 4K, but unlike i386 that's not guaranteed by the ABI.
> At least AMD has indicated that they are considering introducing larger page
> size support in future hardware.

EFI ABI?  Don't you mean the SYSV ABI right.

That does seem to indicate that 64K is an option.  And at a quick
glance glibc is using 1M alignment on program segments so it
looks like there is at least a reasonable chance of being able
to make the transition to a bigger page size for user space.

Eric
