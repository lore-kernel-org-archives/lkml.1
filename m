Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbXD0RDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbXD0RDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbXD0RDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:03:48 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59886 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbXD0RDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:03:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, Michael McConnell <soruk@eridani.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: MAINTAINERS file out of date?
References: <4631255F.9010902@eridani.co.uk>
	<m1647ijvk1.fsf@ebiederm.dsl.xmission.com>
	<4631873B.1000107@zytor.com> <200704271234.32679.ak@suse.de>
	<46321D2E.7000400@zytor.com>
Date: Fri, 27 Apr 2007 11:02:02 -0600
In-Reply-To: <46321D2E.7000400@zytor.com> (H. Peter Anvin's message of "Fri,
	27 Apr 2007 08:56:30 -0700")
Message-ID: <m1lkgdiwdx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Andi Kleen wrote:
>>> A lot of that code (although, of course, not all) could be written in C,
>>> though.  I'm thinking of taking a stab at rewriting it that way.
>> 
>> That would require a new compiler, right? I don't think that would
>> make users very happy.
>> 
>> Besides the code is not exactly that maintenance intensive and only
>> changes rarely so I don't need a pressing need to rewrite it
>
> No, it would not need a new compiler.  All it requires is gcc plus a
> reasonably recent binutils which you need anyway.

There opportunities to enhance this code without writing it in C.
Such as building the code out comprehensible single of subroutines,
with a well defined calling sequence.

The big benefit when you can go to C is that you can include headers
from elsewhere in the kernel and since setup.S is increasingly
becoming optional it has a fixed interface to the rest of
the kernel, so there is much less opportunity for enhancement there.

Eric
