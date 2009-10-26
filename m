Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZJZR6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZJZR6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZJZR6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:58:01 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:54215 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbZJZR5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:57:54 -0400
Subject: Re: symlinks with permissions
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Kara <jack@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
In-Reply-To: <20091026174631.GD7233@duck.suse.cz>
References: <20091025062953.GC1391@ucw.cz>
	 <20091026163157.GB7233@duck.suse.cz> <20091026165729.GF23564@us.ibm.com>
	 <20091026173629.GB16861@fieldses.org>  <20091026174631.GD7233@duck.suse.cz>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 13:57:49 -0400
Message-Id: <1256579869.8576.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 10 sum msgs/h 1 total rcpts 1755 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 805355B74373B07FCF0817A7C99F17073C472384
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 326 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 18:46 +0100, Jan Kara wrote:
>   That's what I'd think as well but it does not as I've just learned and
> tested :) proc_pid_follow_link actually directly gives a dentry of the
> target file without checking permissions on the way.
> 
> 								Honza

I seem to remember that is deliberate, the point being that a symlink
in /proc/*/fd/ may contain a path that refers to a private namespace.

Cheers
  Trond

