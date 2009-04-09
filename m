Return-Path: <linux-kernel-owner+w=401wt.eu-S937331AbZDIXnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937331AbZDIXnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZDIXnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:43:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522AbZDIXnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:43:11 -0400
Date: Thu, 9 Apr 2009 16:39:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: matthieu.castet@parrot.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
       tarmigan@gmail.com
Subject: Re: [PATCH][Checkstack] Don't censor output
Message-Id: <20090409163948.b39e40cd.akpm@linux-foundation.org>
In-Reply-To: <20090406211146.GA10231@logfs.org>
References: <20090406211146.GA10231@logfs.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 23:11:46 +0200
J__rn Engel <joern@logfs.org> wrote:

> Subject: [PATCH][Checkstack] Don't censor output

Please use the form

	subsytem-identifier: what-i-did-to-it

so

	[patch] checkstack: don't censor output

would suit here.

> Date: Mon, 6 Apr 2009 23:11:46 +0200
> User-Agent: Mutt/1.5.13 (2006-08-11)
> 
> For reasons that neither Arnd nor I can remember, the s390 port of
> checkstack happened to ignore stack frames below 300 and above 10000
> bytes.  Later on the same effect - arguably a bug - was copied into the
> arm, ia64, mips and sh64 ports.
> 
> Fixing it also makes the regular expressions shorter and simpler.
> 
>  scripts/checkstack.pl |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- debuggerhead/scripts/checkstack.pl~checkstack	2008-03-05 12:14:05.000000000 +0100
> +++ debuggerhead/scripts/checkstack.pl	2008-11-04 20:38:08.000000000 +0100

The patch fails to apply, yet nobody has changed checkstack.pl in ages.
I think you're tricking me.

