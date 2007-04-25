Return-Path: <linux-kernel-owner+w=401wt.eu-S1030927AbXDYOfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030927AbXDYOfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030924AbXDYOfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:35:18 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:50005 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030927AbXDYOfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:35:16 -0400
Message-ID: <462F6717.70508@namesys.com>
Date: Wed, 25 Apr 2007 18:35:03 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Alex Zarochentsev <zam@namesys.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Eric Hopper <hopper@omnifarious.org>, Lex Lyamin <flx@msu.ru>,
       William Heimbigner <icxcnika@mar.tar.cc>,
       Rik van Riel <riel@redhat.com>, Xu CanHao <xucanhao@gmail.com>
Subject: Re: Question about Reiser4
References: <20070423111939.c876c9cc.akpm@linux-foundation.org> <462E17AF.7090604@namesys.com> <20070424193921.GA17129@one.firstfloor.org>
In-Reply-To: <20070424193921.GA17129@one.firstfloor.org>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

>>Because there are unaddressed items in this todo list:
>>http://pub.namesys.com/Reiser4/ToDo
>>The main issues here are xattrs and support for blocksize != pagesize.
>>    
>>
>
>I would consider both to be optional. We have various file systems
>in tree that don't support either (e.g. JFS only supports 4K blocks
>and OCFS2 doesn't support xattr) They shouldn't block merging.
>
>  
>

xattrs also were considered as some guarantee of vendor support.
If possible, then we'll address it as low-priority issue.
Maybe somebody will help.. (xattrs support should go as incremental
update of FPL-subversion for reiser4 kernel module and reiser4progs).

>>2. Who will maintain this?
>>
>>Currently there are two namesys employees working mostly on
>>enthusiasm. Divide them into 2 file systems, plus many people who
>>really help with fixing problems.
>>    
>>
>
>Merging will probably be a peak of work for the necessary changes,
>then hopefully the work will be less once you're in tree because
>you don't need to track mainline anymore
>(assuming not to many bugs come in from users) 
>
>-Andi
>  
>

Hope we survive this, at least such peaks is not something new in
our practice.

Well, gentlemen, so we'll address other items (except #26, 27) and
resume this discussion.

Thanks,
Edward.

