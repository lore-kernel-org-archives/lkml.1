Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZIDFxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZIDFxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbZIDFxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:53:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630AbZIDFxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:53:47 -0400
Message-ID: <4AA0ABF4.5070502@redhat.com>
Date: Fri, 04 Sep 2009 13:56:04 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: [RFC Patch] kbuild: implement "make foo.s_c"
References: <20090904053233.4396.85814.sendpatchset@localhost.localdomain> <20090903223809.7e303e6c.akpm@linux-foundation.org>
In-Reply-To: <20090903223809.7e303e6c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 4 Sep 2009 01:30:06 -0400 Amerigo Wang <amwang@redhat.com> wrote:
> 
>> This patch implements "make path/to/file.s_c", where
>> "file.s_c" is a file contains both asm and C code, this
>> is helpful for people to do debugging at asm level.
> 
> Try
> 
> 	make path/to/file.lst
> 
> :)

Wow, I never know it before. Thanks!

But the name 'file.lst' is a little bit confusing for me. :-/

How about renaming it to other more meaningful name, e.g.
'file.s_c'? :)

Thanks.
