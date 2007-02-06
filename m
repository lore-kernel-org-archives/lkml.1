Return-Path: <linux-kernel-owner+w=401wt.eu-S1750969AbXBFHZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbXBFHZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 02:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXBFHZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 02:25:10 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60288 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbXBFHZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 02:25:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: vgoyal@in.ibm.com
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Etienne Lorrain <etienne_lorrain@yahoo.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <522909.27613.qm@web26909.mail.ukl.yahoo.com>
	<45C7CDD7.20806@zytor.com> <20070206052514.GA15613@in.ibm.com>
	<45C81D5B.3050408@zytor.com> <20070206063320.GA26462@in.ibm.com>
	<45C82266.3010007@zytor.com> <20070206065104.GB26462@in.ibm.com>
Date: Tue, 06 Feb 2007 00:24:24 -0700
In-Reply-To: <20070206065104.GB26462@in.ibm.com> (Vivek Goyal's message of
	"Tue, 6 Feb 2007 12:21:04 +0530")
Message-ID: <m1abzrvjdj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@in.ibm.com> writes:

> On Mon, Feb 05, 2007 at 10:38:30PM -0800, H. Peter Anvin wrote:
>> Vivek Goyal wrote:
>> >
>> >That time, grub was working fine but lilo had broken on one of Andrew's
>> >machine. I could not reproduce the problem on my setup and had no clue what
>> >was the issue. Hence got rid of ELF header from bzImage which was 
>> >non-essential
>> >stuff for relocatable kernel. But that issue should be fixable.
>> >
>> 
>> Either way, though, putting Gujin-specific code in the main kernel 
>> output is a pretty dull thud.
>> 
>
> Agreed.

Just for documentation the current interface is you come in through
the kernels 16bit entry point and get all of it's BIOS calls, or your
bootloader is responsible for getting the equivalent information
somehow.

>From what little I skimmed part of what Gujin wanted to do was sane
at first glance. Just boot a gziped vmlinux like the other
architectures.  The problem was the 16bit code.  

So there may be some good ideas buried in there somewhere, but it
likely to take some doing, and patches that I have to save before
I read them are a real pain!

Eric
