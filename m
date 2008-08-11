Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbYHKKgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbYHKKgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 06:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYHKKgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 06:36:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:52933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbYHKKgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 06:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oUTtfBhl+Te8C2MoPYjGOJ9zUyTZ/6VlAca6afk2cy0pZ5AZ/AiWdPJmxLIl7c/jVN
         LDci80fgzZeQcy+FRISsjjjn5QXumxEfyNpaVvVS1TrjRGXuhFJ81j112se/D+pNV40f
         c4bmwcop9cw4AJv91nW07NfAT4y6jLaQu+TZM=
Message-ID: <4104961b0808110336x74676e9ane135d2e8c11ccea@mail.gmail.com>
Date: Mon, 11 Aug 2008 18:36:35 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: jmerkey@wolfmountaingroup.com
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 1:22 AM,  <jmerkey@wolfmountaingroup.com> wrote:
>
>
> This is a linux port of the kernel debugger I wrote in 2000 for the
> MANOS/Gadugi Operating System.  I created this particular
> port in June of this year from the MANOS/Gadugi source code I released
> under the GNU public license in 2000.
>
> I wrote the SMP debugger use in SMP Netware in 1994 and 1995, and that was
> later rolled into the main Netware kernel, though a lot of folks
> contributed helped merge it into Netware.  This debugger closely resembles
> the legacy Netware kernel debugger, and I find it easier to use than kdb
> with less
> crashes and problems.
>
> This version is ia32 only at present, but I am completing x86_64 support
> and will post it as it is completed.  I basically wrote this tool for
> my own internal use and for my projects since I could not find a debugger
> in linux I was used to.  I add support to it as I need it for my own
> internal use.
>
> This linux port of my kernel debugger does not require kdb or the kdb hooks
> and is more minimal than kdb and has some features kdb does not, such as
> Intel style disassembly with dereferencing of data during disassembly
> and a very robust mathematical numeric support with conditional breakpoints.
>
> I created a far more robust version of this debugger in 2001 which
> included source level support, integrated screen and keyboard support,
> remote networking capability, and loader support and licensed it to another
> company.  I was placed under a 5 year non-compete not to port
> this tool to Linux until end of year 2007.  The folks who licensed it
> did absolutely nothing with it of consequence, and 2007 has come and gone,
> so I am released from the non-compete and decided to port the debugger
> from my old Open Source operating system and I figured it might be as useful
> to others as it has been for my projects.
>
> I will be posting user space modules which can be loaded with this version
> at some point which will enable source level debugging and a bunch of
> other features.  This add ons may get farmed out to another company for
> support.
>
> KNOWN ISSUES
> ------------
>
> This debugger works very well on SMP systems, but some of the directed
> NMI features are intended for post mortem crashed systems.
>
> All numbers entered are interpreted as hex.  If you want a number
> interpreted from the debugger console in decimal, add an 'r' to the end of
> the number for "real number".
>
> There is awesome help support in the debugger.  type "help" or "help
> <command name>".
>
> I have support for post-mortem directed NMI breakpoints from the debugger
> console if you want to halt another processor which can hang on some
> systems, but usually does not.
>
> I do not have ia64 support and since Intel in 2000 refused to share ia64
> information with me, I never completed the ia64 section of the debugger.
> If and when I obtain an ia64 system, I will look into putting it in or
> try to adapt the disassembler out of kdb which has ia64 and x86_64 support.
>
>
>
> vanilla kernels
>
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.18-ia32-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.19-ia32-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.20-ia32-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.21-ia32-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.22-ia32-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.23-ia32-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.24-ia32-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.25-ia32-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.26-ia32-08-02-08.patch
>
>
> Linux distributions
>
> ftp://ftp.wolfmountaingroup.org/pub/mdb/distro/mdb-2.6.16-ia32-SLES-10-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/distro/mdb-2.6.18-el5-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/distro/mdb-2.6.22.5-31-ia32-suse10.3-08-01-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/distro/mdb-2.6.23-ia32-fc8-08-02-08.patch
> ftp://ftp.wolfmountaingroup.org/pub/mdb/distro/mdb-2.6.25.14-ia32-fc9-08-02-08.patch
>
> Any additional code fixes I would appreciate being placed back into the
> tree, so please sent them back to me if you find the debugger useful.
>
> I commend Keith Owens for his work on kdb and his project is more than
> welcome to share and adapt the code from mdb if it is useful for their
> project.  I am certainly looking seriously at using the disassembler in
> kdb for mdb, with my enhancements rolled into it.
>
> Jeffrey Vernon Merkey
>
>
Well I think given the fact that kdb is not accepted by Linus, there
is little possibility that mdb will be included in mainline kernel.
Though I don't know why kgdb is acceptable.

Regards
Jason Xiao
