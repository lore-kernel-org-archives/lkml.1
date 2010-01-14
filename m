Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923Ab0ANGSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab0ANGSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 01:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411Ab0ANGSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 01:18:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0ANGSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 01:18:34 -0500
Message-ID: <4B4EB7CB.2030807@redhat.com>
Date: Thu, 14 Jan 2010 01:20:59 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf probe: Fix build failure
References: <4B4E8993.5080404@cn.fujitsu.com> <4B4EA2BC.9000307@redhat.com> <4B4EAA54.9000109@cn.fujitsu.com>
In-Reply-To: <4B4EAA54.9000109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Masami Hiramatsu wrote:
>> Hi,
>>
>> Thank you, the patch code looks good to me.
>>
>> Li Zefan wrote:
>>> builtin-probe.c:121: error: 'opt_show_lines' defined but not used
>>
>> Please add some comment for explanation, like:
>>
>> This build error occurs when compiling perf-tools without dwarf
>> support (no libdwarf).
>>
> 
> But as simple as this patch, the code itself has explained
> the cause of this compile error.

If someone looks git-log afterwords, below message seems too
short.
---
perf probe: Fix build failure

builtin-probe.c:121: error: 'opt_show_lines' defined but not used
---
Especially, if there is libdwarf, we will not see above error. So
IMHO, at least we'd better add a comment about how the error occurs.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

