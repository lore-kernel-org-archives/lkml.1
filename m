Return-Path: <linux-kernel-owner+w=401wt.eu-S1161199AbXDWGTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161199AbXDWGTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161216AbXDWGTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:19:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49174 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161199AbXDWGTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:19:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: vgoyal@in.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jurriaan <thunder7@xs4all.nl>, Helge Hafting <helgehaf@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus@valinux.co.jp>,
       Horms <horms@verge.net.au>, fastboot@osdl.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/2] x86_64: Remove CONFIG_PHYSICAL_START and CONFIG_RELOCATABLE
References: <20070331232957.e1c93f19.akpm@linux-foundation.org>
	<20070402074159.GA13704@in.ibm.com>
	<m1abxrf9o3.fsf@ebiederm.dsl.xmission.com>
	<20070402094520.GC13704@in.ibm.com>
	<m1648eg01d.fsf@ebiederm.dsl.xmission.com>
	<20070403040152.GA5108@in.ibm.com>
	<m1zm5qc9q2.fsf@ebiederm.dsl.xmission.com>
	<20070403100349.GA21759@in.ibm.com>
	<m18xcjznbm.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pn7zn5n.fsf_-_@ebiederm.dsl.xmission.com>
	<20070423060739.GA14664@in.ibm.com>
Date: Mon, 23 Apr 2007 00:17:22 -0600
In-Reply-To: <20070423060739.GA14664@in.ibm.com> (Vivek Goyal's message of
	"Mon, 23 Apr 2007 11:37:39 +0530")
Message-ID: <m1slary5ql.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@in.ibm.com> writes:

> On Sun, Apr 22, 2007 at 11:15:48PM -0600, Eric W. Biederman wrote:
>> +++ b/arch/x86_64/Kconfig
>> @@ -565,62 +565,9 @@ config CRASH_DUMP
>>            which are loaded in the main kernel with kexec-tools into
>>            a specially reserved region and then later executed after
>>            a crash by kdump/kexec. The crash dump kernel must be compiled
>> -	  to a memory address not used by the main kernel or BIOS using
>> -	  PHYSICAL_START.
>> +	  to a memory address not used by the main kernel or BIOS
>>            For more details see Documentation/kdump/kdump.txt
>
> Hi Eric,
>
> I think "must be compiled" should be replaced with "must be loaded" now.

Yes, that sounds right.  Ugh.  I didn't look at enough context to read
the whole sentence.  I just killed the part about PHYSICAL_START.

> Otherwise both the patches look fine.  I am planning to test these.
>
> This change will also require modifications to Documentation/kdump/kdump.txt
> file.

Do you think you can generate the patch fix up the CONFIG_CRASH_DUMP
and kdump.txt documentation.

I was just interested enough to spend the 15 minutes needed to generate
this patch.  I don't think I care enough to dot the i's and cross the t's
in the documentation.

Eric
