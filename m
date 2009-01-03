Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbZACXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbZACXCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbZACXCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:02:01 -0500
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:58458 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZACXCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:02:00 -0500
Message-ID: <495FEE66.9080903@ribosome.natur.cuni.cz>
Date: Sun, 04 Jan 2009 00:01:58 +0100
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081227 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Duane Griffin <duaneg@dghda.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
References: <20090103123813.GA1512@ucw.cz> <495FD5D7.2040907@ribosome.natur.cuni.cz> <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com> <20090103222957.GG1666@elf.ucw.cz>
In-Reply-To: <20090103222957.GG1666@elf.ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2009-01-03 22:17:15, Duane Griffin wrote:
>> [Fixed top-posting]
>>
>> 2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
>>> Pavel Machek wrote:
>>>> readonly mount does actually write to the media in some cases. Document that.
>>>>
>>> Can one avoid replay of the journal then if it would be unclean?
>>> Just curious.
>> Nope. If the underlying block device is read-only then mounting the
>> filesystem will fail. I tried to fix this some time ago, and have a
>> set of patches that almost always work, but "almost always" isn't good
>> enough. Unfortunately I never managed to figure out a way to finish it
>> off without disgusting hacks or major surgery.
> 
> Uhuh, can you just ignore the journal and mount it anyway?
> ...basically treating it like an ext2?
> 
> ...ok, that will present "old" version of the filesystem to the
> user... violating fsync() semantics.

Hmm, so if my dual-boot machine does not shutdown correctly and I boot
accidentally in M$ Win where I use ext2 IFS driver and modify some
stuff on the ext3 drive, after a while reboot to linux and the journal
get re-played ... Mmm ...

> 
> Still handy for recovering badly broken filesystems, I'd say.

Me as well. How about improving you doc patch with some summary of
this thread (although it is probably not over yet)? ;-) Definitely,
a note that one can mount it as ext2 while read-only would be helpful
when doing some forensics on the disk.

