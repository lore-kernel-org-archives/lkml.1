Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162Ab0ANFXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0ANFXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831Ab0ANFXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:23:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63418 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab0ANFXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:23:34 -0500
Message-ID: <4B4EAA54.9000109@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 13:23:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf probe: Fix build failure
References: <4B4E8993.5080404@cn.fujitsu.com> <4B4EA2BC.9000307@redhat.com>
In-Reply-To: <4B4EA2BC.9000307@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Hi,
> 
> Thank you, the patch code looks good to me.
> 
> Li Zefan wrote:
>> builtin-probe.c:121: error: 'opt_show_lines' defined but not used
> 
> Please add some comment for explanation, like:
> 
> This build error occurs when compiling perf-tools without dwarf
> support (no libdwarf).
> 

But as simple as this patch, the code itself has explained
the cause of this compile error.

