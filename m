Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYHNRQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYHNRQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYHNRQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:16:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44647 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYHNRQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:16:22 -0400
Date: Thu, 14 Aug 2008 10:15:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: Would it be better for git-commits-head to have -M -C diffs?
Message-Id: <20080814101541.905ccc8f.randy.dunlap@oracle.com>
In-Reply-To: <m3ljyzsfg6.fsf@lugabout.jhcloos.org>
References: <m3ljyzsfg6.fsf@lugabout.jhcloos.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 12:56:18 -0400 James Cloos wrote:

> Would anyone else prefer to see the posts on the commits list use git's
> copy and move detection?
> 
> Git show (used by the feed-mail-list script) does support -M and -C.
> 
> It does affect the stat section.  The recent commit 758db3f21187 would
> have had its stat changed from looking like:
> 
>  arch/h8300/include/asm/Kbuild              |    1 +
>  arch/h8300/include/asm/a.out.h             |   20 ++
>  arch/h8300/include/asm/atomic.h            |  144 +++++++++++
>                         .
>                         .
>                         .
>  include/asm-h8300/Kbuild                   |    1 -
>  include/asm-h8300/a.out.h                  |   20 --
>  include/asm-h8300/atomic.h                 |  144 -----------
>                         .
>                         .
>                         .
> 
> to looking like:
> 
>  .../asm-h8300 => arch/h8300/include/asm}/Kbuild    |    0 
>  .../asm-h8300 => arch/h8300/include/asm}/a.out.h   |    0 
>  .../asm-h8300 => arch/h8300/include/asm}/atomic.h  |    0 
>  .../asm-h8300 => arch/h8300/include/asm}/auxvec.h  |    0 
>  .../asm-h8300 => arch/h8300/include/asm}/bitops.h  |    0 
>  .../h8300/include/asm}/bootinfo.h                  |    0 
>                         .
>                         .
>                         .
> 
> but would have been 512 lines and 24271 octets instead of 10623 lines
> and 291634 octets.
> 
> I think it would also be useful were the From: header of each message
> set to the commit's Author.  I run each commit through a script to do
> that locally, but the archives would also benefit from that.


or the git-commits list could use what Linus has requested to be used
in pull requests:

Please use "git diff -M --stat --summary" to generate the diffstat:
the -M enables rename detection, and the summary enables a summary of
new/deleted or renamed files.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
