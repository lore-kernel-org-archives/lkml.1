Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbYDWMdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbYDWMdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYDWMcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:32:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYDWMcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:32:52 -0400
Date: Wed, 23 Apr 2008 08:32:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kdb@oss.sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kexec@lists.infradead.org, Keith Owens <kaos@ocs.com.au>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Randy Dunlap <rdunlap@xenotime.net>, greg@kroah.com, bwalle@suse.de,
       k-miyoshi@cb.jp.nec.com
Subject: Re: [PATCH 0/3] add new notifier function ,take4
Message-ID: <20080423123233.GA23066@redhat.com>
References: <480F1957.2070609@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480F1957.2070609@ah.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 08:11:19PM +0900, Takenori Nagano wrote:
> Hi,
> 
> changelog take3 -> take4
> 
> - Rebased 2.6.25-mm1
> - Add a document
> - Add kdump on panic_notifier
> 
> These patches add new notifier function and implement it to panic_notifier_list.
> We used the hardcoded notifier chain so far, but it was not flexible. New
> notifier is very flexible, because user can change a list of order by control files.
> 
> And, third patch moves crash_kexec() to panic_notifier. It helps us to do
> something before taking a crash dump. It's useful for some RAS tools developer.

Hi Takenori,

What's the "something" which you want to do after panic and before kdump.
Can you please give a concrete example. We have talked about this quite
a few times but nothing concrete has come out so far, except a generic
statement that it helps "RAS tool developers".

The only thing we could think of was debuggers (kdb and kgdb) and one easy
solution is that debuggers/users can put a break point at panic() instead
of introducing this infrastructure.

Thanks
Vivek
