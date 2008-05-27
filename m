Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYE0ImI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYE0ImI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbYE0Ily
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:41:54 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:2400 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbYE0Ilx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:41:53 -0400
Message-ID: <483BC91C.5050004@de.ibm.com>
Date: Tue, 27 May 2008 10:41:00 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>,
       linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 5/7] gcov: add gcov profiling infrastructure
References: <48313DE6.30802@de.ibm.com> <20080523001136.59ec8b34.akpm@linux-foundation.org> <20080523084506.GB719@linux-mips.org>
In-Reply-To: <20080523084506.GB719@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> On Fri, May 23, 2008 at 12:11:36AM -0700, Andrew Morton wrote:
>> On Mon, 19 May 2008 10:44:22 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
>> 
>> > +	Note that a kernel compiled with profiling flags will be significantly
>> > +        larger and run slower. Also be sure to exclude files from profiling
>> > +        which are not linked to the kernel image to prevent linker errors.
>> 
>> heh, it was all too much for mips.
>> 
>> {standard input}: Assembler messages:
>> {standard input}:2716: Error: Branch out of range
>> {standard input}:2819: Error: Branch out of range
>> {standard input}:2884: Error: Branch out of range
>> {standard input}:3032: Error: Branch out of range
>> {standard input}:3097: Error: Branch out of range
>> {standard input}:3151: Error: Branch out of range
>> {standard input}:3216: Error: Branch out of range
>> make[1]: *** [drivers/telephony/ixj.o] Error 1
>> make: *** [drivers/telephony/ixj.o] Error 2
> 
> A known problem which I had decieded to ignore until it begins to actually
> bite.

I don't suppose there is an easy way to fix/work around this, is there?
