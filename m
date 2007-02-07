Return-Path: <linux-kernel-owner+w=401wt.eu-S965239AbXBGCt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965239AbXBGCt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 21:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXBGCt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 21:49:26 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40175 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965239AbXBGCtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 21:49:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Etienne Lorrain <etienne_lorrain@yahoo.fr>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Re : Re : Re : Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <965140.82745.qm@web26914.mail.ukl.yahoo.com>
	<45C9246F.9050300@zytor.com>
Date: Tue, 06 Feb 2007 19:48:43 -0700
In-Reply-To: <45C9246F.9050300@zytor.com> (H. Peter Anvin's message of "Tue,
	06 Feb 2007 16:59:27 -0800")
Message-ID: <m14ppyr8c4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Etienne Lorrain wrote:
>> H. Peter Anvin wrote:
>>> I've long wished that someone would do a proper 16-bit x86 port of gcc;
>>
>>> however, the .code16gcc is usually good enough, although it produces code
>>> which is a lot bigger than it needs to be.
>>
>>   It is only that much bigger if you compare to 16 bits integer compilers,
>>  but once you deal with 32 bits integers in real mode you have one extra byte
>>  out of the two - which is still better than dealing with dx:ax.
>>
>>  Last time I compiled (long time ago) some piece of code with and without
>>  .code16gcc it was approx 15% bigger - approx what you get when optimising.
>>
>
> That's not a valid comparison, because you're using 32-bit registers to hold
> 16-bit pointers, and then sticking 67 prefixes on completely unnecessarily.

Regardless if the size is good enough we can use it :)

For romcc I had a 3x code bloat over had crafted assembler, because I
had no memory and had to inline every single function call because I
didn't have someplace to put a return register.  So I have the
scenario with the most code bloat.  I win!

Eric
