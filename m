Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbXEHTjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbXEHTjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXEHTjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:39:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50018 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbXEHTjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:39:39 -0400
Date: Tue, 8 May 2007 12:43:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CodingStyle: start flamewar about use of braces
Message-Id: <20070508124301.17975a4f.randy.dunlap@oracle.com>
In-Reply-To: <200705081903.l48J3AOw010373@hera.kernel.org>
References: <200705081903.l48J3AOw010373@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 19:03:10 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e659ba4a0d2d471c0d73590f78e1a1b5a1eede48
> Commit:     e659ba4a0d2d471c0d73590f78e1a1b5a1eede48
> Parent:     28be5abb400e5e082f5225105fdc69337ec0c0b4
> Author:     Oliver Neukum <oliver@neukum.org>
> AuthorDate: Tue May 8 00:30:34 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Tue May 8 11:15:12 2007 -0700
> 
>     CodingStyle: start flamewar about use of braces

It worked somewhat.  We never did reach any kind of
concensus about this....


>     Signed-off-by: Oliver Neukum <oneukum@suse.de>
>     Cc: Tilman Schmidt <tilman@imap.cc>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  Documentation/CodingStyle |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 9069189..e7f5fc6 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -160,6 +160,21 @@ supply of new-lines on your screen is not a renewable resource (think
>  25-line terminal screens here), you have more empty lines to put
>  comments on.
>  
> +Do not unnecessarily use braces where a single statement will do.
> +
> +if (condition)
> +	action();
> +
> +This does not apply if one branch of a conditional statement is a single
> +statement. Use braces in both branches.
> +
> +if (condition) {
> +	do_this();
> +	do_that();
> +} else {
> +	otherwise();
> +}
> +
>  		3.1:  Spaces
>  
>  Linux kernel style for use of spaces depends (mostly) on


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
