Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000Ab0AVUQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0AVUQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 15:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946Ab0AVUQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 15:16:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1439 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab0AVUQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 15:16:34 -0500
Subject: Re: [PATCH] get_maintainer.pl: teach git log to use --no-color
From: Joe Perches <joe@perches.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264163484.2143.13.camel@localhost>
References: <1264163484.2143.13.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 12:16:33 -0800
Message-ID: <1264191393.32383.128.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lOn Fri, 2010-01-22 at 12:31 +0000, Richard Kennedy wrote:
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index 090f248..2cae27a 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -74,7 +74,7 @@ my %VCS_cmds;
>  my %VCS_cmds_git = (
>      "execute_cmd" => \&git_execute_cmd,
>      "available" => '(which("git") ne "") && (-d ".git")',
> -    "find_signers_cmd" => "git log --since=\$email_git_since -- \$file",
> +    "find_signers_cmd" => "git log --no-color --since=\$email_git_since -- \$file",
>      "find_commit_signers_cmd" => "git log -1 \$commit",
>      "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
>      "blame_file_cmd" => "git blame -l \$file",

Actually, I take back my ack.

The line immediately below your change also needs --no-color

Can you make that change and resubmit please?

cheers, Joe

