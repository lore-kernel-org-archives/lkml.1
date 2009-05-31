Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZEaCXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZEaCXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 22:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZEaCXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 22:23:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56797 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbZEaCXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 22:23:10 -0400
Message-ID: <4A21EA8E.6060507@redhat.com>
Date: Sun, 31 May 2009 10:25:18 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Patch] kbuild: fix a compile warning
References: <20090515075229.11346.6710.sendpatchset@localhost.localdomain> <20090528004100.3716e00d.akpm@linux-foundation.org>
In-Reply-To: <20090528004100.3716e00d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 15 May 2009 03:51:18 -0400 Amerigo Wang <amwang@redhat.com> wrote:
>
>   
>> I got this warning:
>>     
>
> With which gcc version?
>   

gcc version 4.4.0 (GCC)

>   
>>  HOSTCC  scripts/basic/fixdep
>> scripts/basic/fixdep.c: In function 'traps':
>> scripts/basic/fixdep.c:377: warning: dereferencing type-punned pointer will break strict-aliasing rules
>> scripts/basic/fixdep.c:379: warning: dereferencing type-punned pointer will break strict-aliasing rules
>>
>>     
>
> (wtf?)
>   

Try the man page of gcc for -fstrict-aliasing. :)

