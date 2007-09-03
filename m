Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbXICR30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbXICR30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 13:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbXICR3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 13:29:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:52568 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751332AbXICR3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 13:29:16 -0400
Date: Mon, 3 Sep 2007 19:48:46 +0200
From: Jan Kara <jack@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Send quota messages via netlink
Message-ID: <20070903174846.GJ7524@duck.suse.cz>
References: <20070828141318.GC5869@duck.suse.cz> <20070828215128.d8147a43.akpm@linux-foundation.org> <20070903144336.GH7524@duck.suse.cz> <20070903101234.c74ead59.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070903101234.c74ead59.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 03-09-07 10:12:34, Randy Dunlap wrote:
> On Mon, 3 Sep 2007 16:43:36 +0200 Jan Kara wrote:
> 
> > User-Agent: Mutt/1.5.13 (2006-08-11)
> 
> Mutt knows how to send patches inline vs. attachments... :(
  Hmm, I thought Andrew either does not mind or prefers attachments. If
it isn't the case, I can inline patches. Andrew? BTW: I personally prefer
attachments - mutt inlines text attachments for me anyway and sometimes
it's useful to have the file structured by MIME.

> +This command is used to send a notification about any of the above mentioned
> +events. Each message has six attributes. These are (type of the argument is
> +in braces):
> 
> s/braces/parentheses/
> 
> +        QUOTA_NL_A_QTYPE (u32)
> +	  - type of quota beging exceeded (one of USRQUOTA, GRPQUOTA)
> 
> s/beging/being/
  Thanks for reading it. Andrew, should I resend the patch or will you
substitute it in the patch?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
