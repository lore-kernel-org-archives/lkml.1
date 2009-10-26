Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZJZSWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZJZSWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZJZSWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:22:20 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:60661 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZJZSWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:22:18 -0400
Subject: Re: symlinks with permissions
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
In-Reply-To: <20091025093604.GA1501@ucw.cz>
References: <20091025062953.GC1391@ucw.cz>
	 <20091026163157.GB7233@duck.suse.cz> <20091026165729.GF23564@us.ibm.com>
	 <20091026173629.GB16861@fieldses.org> <20091026174631.GD7233@duck.suse.cz>
	 <1256579869.8576.7.camel@heimdal.trondhjem.org>
	 <20091025093604.GA1501@ucw.cz>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 14:22:16 -0400
Message-Id: <1256581336.8576.20.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 12 sum msgs/h 1 total rcpts 1763 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 94BFF04572A90F39D16D44F930C839C60A1E433E
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 327 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 10:36 +0100, Pavel Machek wrote:
> Well, it is unexpected and mild security hole.
> 
> Part of the problem is that even  if you have read-only
> filedescriptor, you can upgrade it to read-write, even if path is
> inaccessible to you.
> 
> So if someone passes you read-only filedescriptor, you can still write
> to it.
> 									Pavel

If someone passes you a file descriptor, can't you in any case play
games with, openat(fd,"",O_RDWR), in order to achieve the same thing? I
must admit I haven't tried it yet, but at a first glance I can't see
anything that prevents me from doing this...

Cheers
  Trond

