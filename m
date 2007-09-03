Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbXICSmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbXICSmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXICSmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:42:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786AbXICSmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:42:39 -0400
Date: Mon, 3 Sep 2007 11:41:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Send quota messages via netlink
Message-Id: <20070903114109.ebfeb0b7.akpm@linux-foundation.org>
In-Reply-To: <20070903174846.GJ7524@duck.suse.cz>
References: <20070828141318.GC5869@duck.suse.cz>
	<20070828215128.d8147a43.akpm@linux-foundation.org>
	<20070903144336.GH7524@duck.suse.cz>
	<20070903101234.c74ead59.randy.dunlap@oracle.com>
	<20070903174846.GJ7524@duck.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 3 Sep 2007 19:48:46 +0200 Jan Kara <jack@suse.cz> wrote:
> On Mon 03-09-07 10:12:34, Randy Dunlap wrote:
> > On Mon, 3 Sep 2007 16:43:36 +0200 Jan Kara wrote:
> > 
> > > User-Agent: Mutt/1.5.13 (2006-08-11)
> > 
> > Mutt knows how to send patches inline vs. attachments... :(
>   Hmm, I thought Andrew either does not mind or prefers attachments. If
> it isn't the case, I can inline patches. Andrew? BTW: I personally prefer
> attachments - mutt inlines text attachments for me anyway and sometimes
> it's useful to have the file structured by MIME.

inlined is a bit better, mainly because one can reply to it and the email
client will quote the whole thing.

> > +This command is used to send a notification about any of the above mentioned
> > +events. Each message has six attributes. These are (type of the argument is
> > +in braces):
> > 
> > s/braces/parentheses/
> > 
> > +        QUOTA_NL_A_QTYPE (u32)
> > +	  - type of quota beging exceeded (one of USRQUOTA, GRPQUOTA)
> > 
> > s/beging/being/
>   Thanks for reading it. Andrew, should I resend the patch or will you
> substitute it in the patch?

I'll sort it out, thanks.
