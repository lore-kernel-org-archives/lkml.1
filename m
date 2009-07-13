Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbZGMAry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbZGMAry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 20:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZGMArp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 20:47:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60977 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZGMArp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 20:47:45 -0400
Message-ID: <4A5A8430.7050300@cn.fujitsu.com>
Date: Mon, 13 Jul 2009 08:47:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: Add missing __init in ftrace_profile_debugfs()
References: <b9df5fa10907120358t7101511cle30e025c3adcbe54@mail.gmail.com>
In-Reply-To: <b9df5fa10907120358t7101511cle30e025c3adcbe54@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakib Mullick wrote:
>  Impact: Fix section mismatch.
> 
> The function ftrace_profile_debugfs() references a variable placed in
> .init.data section. Thus causes a section mismatch warning. Since
> ftrace_profile_debugfs() has been called from only
> ftrace_init_debugfs, so we can safely mark ftrace_profile_debugfs as

Thanks. It has been fixed by commit
9d9949ce45b42be7a8157ea00fff2b1005ed844a in tip tree

> init. Also it contains a trivial style fix, __init should be placed
> between function type and function name (ftrace_init_debugfs).
> 

I think both styles are Ok.

