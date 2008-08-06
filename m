Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbYHFQy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbYHFQy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbYHFQxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:53:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034AbYHFQxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:53:45 -0400
Message-ID: <4899D6AA.4000501@redhat.com>
Date: Wed, 06 Aug 2008 12:51:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1-git5 2/26] mdb: correct kprobes int3 trap
References: <200808050626.m756QZ1g003755@wolfmountaingroup.com>    <489872C5.2040508@redhat.com> <39379.166.70.238.45.1217950104.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <39379.166.70.238.45.1217950104.squirrel@webmail.wolfmountaingroup.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
>> Hi Jeffery,
>>
>> Could you explain what is MDB and how it works?
> 
> 
> MDB is a kernel debugger that uses the same general architecture
> as the kernel debugger in Netware.  Unlike the variants of GNU
> debuggers, MDB is geared towards folks from the intel/microsoft worlds
> who are more accustomed to the old school Intel assembler model and
> not the GNU variant that looks like an angry typewriter cursing at
> the screen (%#*&!, etc.).

Would you have any document about MDB, or project-site url?
I think it is hard for anyone to understand what you like to
do only from these big patchset.

> MDB has some features not yet in this first patch, but I will be adding to
> subsequent patches like the ability to create time based traces of
> execution of code just like an ice does so you can set trigger breakpoints
> (kdb does not, nor kgdb), then go back ad look what happened in windows of
> time, as well as a much easier interface, smaller size, more flexible and
> pluggable command architecture -- a best of all -- it works and does not
> crash every other release or on every third vendors PC architecture like
> kdb does all the time.

Would you have talked with kdb/kgdb people?
Since linux kernel already have kgdb, I think you might better talk
about merging your functionality (and stability) to kgdb, or at least
talk about what part both debugger can share.

> It has been in use by me since 1997, when I wrote it after I left Novell.
> It is mature, hardened, and very stable -- and follows an architecture
> prove in the industry for over 20 years on Netware.

Out of curiously, is there anyone except for you using MDB?

Thank you,

>> And please check your patch style by using scripts/checkpatch.pl.
>> Your cording style seem to be different from linux coding style...
>>
>> Thank you,
> 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

