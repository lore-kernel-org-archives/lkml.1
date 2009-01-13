Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZAMDYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZAMDYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZAMDYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:24:37 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:42658 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZAMDYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:24:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v8Ehunx4PDNi3XHpKUGGKrFkhiFJz2270rPF2/GyhhZmzMRV18DnR6qq1CCeKaFlQO
         hiL67HEKFloJ7H6VZ8CUzjCvPoqj7XhKnt7VhuRZgGDFVUwVfhnNgdkS0EajN8X8TqZZ
         qH3Z+9S/RLoKLrALrsEX2meRK6w6ASrFHmH0w=
MIME-Version: 1.0
In-Reply-To: <200901112001.00394.rjw@sisk.pl>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <3f9a31f40901110546h4c069b5dx9726a0fbf8caf5a1@mail.gmail.com>
	 <20090111135237.GA20184@elte.hu> <200901112001.00394.rjw@sisk.pl>
Date: Tue, 13 Jan 2009 08:54:33 +0530
Message-ID: <3f9a31f40901121924v86b528er652b27e670c5fe0@mail.gmail.com>
Subject: Re: 2.6.29-rc1: Reported regressions from 2.6.28
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Mon, Jan 12, 2009 at 12:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday 11 January 2009, Ingo Molnar wrote:
>>
>> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>>
>> > On Sun, Jan 11, 2009 at 4:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > >
>> > > Regressions with patches
>> > > ------------------------
>> > >
>> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12428
>> > > Subject         : Build error on latest git
>> > > Submitter       : Petr Titera <P.Titera@century.cz>
>> > > Date            : 2009-01-11 9:49 (1 days old)
>> > > References      : http://marc.info/?l=linux-kernel&m=123166856318712&w=4
>> > > Handled-By      : Petr Titera <P.Titera@century.cz>
>> > > Patch           : http://marc.info/?l=linux-kernel&m=123167509024996&w=4
>> >
>> > This is a wrong fix, asm/smp.h should only be included when CONFIG_SMP
>> > is defined.
>> >
>> > I am still in the process of cleaning non-smp data from asm/smp.h for
>> > x86
>> >
>> > Attach patch is the solution for the time being
>> >
>> > Ingo, can you please put this in urgent queue.
>>
>> yes, it already is - see below.
>
> Link to this patch was added to the bug entry.  Pleaes let me know or close the
> bug when it's merged.
>

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4884d8e6a05026ec906355436cea9dc1acb1d09e

--
JSR
