Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbZAIGpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbZAIGpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZAIGpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:45:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZAIGo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:44:59 -0500
Message-ID: <4966F230.4020905@cn.fujitsu.com>
Date: Fri, 09 Jan 2009 14:44:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>	 <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>	 <4966EEDD.5070204@cn.fujitsu.com> <6599ad830901082237l664fb403y386482a577ed185e@mail.gmail.com>
In-Reply-To: <6599ad830901082237l664fb403y386482a577ed185e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Jan 8, 2009 at 10:29 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Agreed, but it can't work by just removing the checking in cgroup mount option,
> 
> Right - it's more complicated than that. There are some places in the
> code that rely on the fact that every hierarchy currently has at least
> one subsystem (anything that uses find_first_subsystem() for example)
> and we'd need to work around that.
> 

And some other problems, like what's the semantic of /proc/<pid>/cgroup when
using none subsys.

I'm afraid even if it's do-able it might require a lot of changes in cgroup.


