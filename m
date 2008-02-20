Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbYBTGO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbYBTGO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYBTGOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:14:47 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:39893 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbYBTGOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:14:46 -0500
To: menage@google.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org
Subject: Re: [PATCH 0/2] cgroup map files: Add a key/value map file type to
 cgroups
In-Reply-To: Your message of "Tue, 19 Feb 2008 22:02:00 -0800"
	<6599ad830802192202t19c1f597jb7927e975eb80aa6@mail.gmail.com>
References: <6599ad830802192202t19c1f597jb7927e975eb80aa6@mail.gmail.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080220061444.D65BD1E3C11@siro.lan>
Date: Wed, 20 Feb 2008 15:14:44 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Feb 19, 2008 9:48 PM, YAMAMOTO Takashi <yamamoto@valinux.co.jp> wrote:
> >
> > it changes the format from "%s %lld" to "%s: %llu", right?
> > why?
> >
> 
> The colon for consistency with maps in /proc. I think it also makes it
> slightly more readable.

can you be a little more specific?

i object against the colon because i want to use the same parser for
/proc/vmstat, which doesn't have colons.

btw, when making ABI changes like this, can you please mention it
explicitly in the patch descriptions?

> For %lld versus %llu - I think that cgroup resource APIs are much more
> likely to need to report unsigned rather than signed values. In the
> case of the memory.stat file, that's certainly the case.
> 
> But I guess there's an argument to be made that nothing's likely to
> need the final 64th bit of an unsigned value, whereas the ability to
> report negative numbers could potentially be useful for some cgroups.
> 
> Paul

i don't have any strong opinions about signedness.

YAMAMOTO Takashi
