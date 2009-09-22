Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZIVGaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZIVGaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZIVGat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:30:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59785 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbZIVGas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:30:48 -0400
Message-ID: <4AB86ED1.1040200@cn.fujitsu.com>
Date: Tue, 22 Sep 2009 14:29:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com> <1253585691-10987-2-git-send-email-dwalker@fifo99.com> <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
In-Reply-To: <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> There are times when maintainers intentially don't follow the coding
> style. When that happens it means some errors need to be ignored, so
> that other errors can be focused on.
> 
> To handle that I added a blacklist to checkpatch. The blacklist holds the
> file names and errors which are ignored. The output is modified to
> remove the errors from the list and not to count them.
> 
> When the blacklist kicks in there is a note that does list how many
> errors got removed and that it was due to a blacklist entry. There is
> also a new option "--noblacklist" that allows the errors to be added
> back as it was without the blacklist.
> 

So, for this piece of code:

TRACE_EVENT(...

	TP_fast_assign(
		__entry->foo = bar( xxx );
	),
)

checkpatch won't report the spaces inside bar()?
If so, I don't like this patch.

Could you just teach checkpatch to recognize those macros used
in TRACE_EVENT(), if those coding-style "errors" bother you
so much that you can't put up with them?

