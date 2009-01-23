Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbZAWANa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbZAWANa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbZAWANU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:13:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbZAWANT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:13:19 -0500
Date: Thu, 22 Jan 2009 19:13:07 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <smfrench@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] [PATCH] cifs: wrap cifs_dnotify_thread in
	CONFIG_BROKEN
Message-ID: <20090123001306.GA2176@infradead.org>
References: <1232642078-9717-1-git-send-email-jlayton@redhat.com> <20090122210655.GA6065@infradead.org> <524f69650901221513m7857488by6713eca64ee31681@mail.gmail.com> <20090122183115.1cef1b53@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122183115.1cef1b53@tleilax.poochiereds.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 06:31:15PM -0500, Jeff Layton wrote:
> Removing this kthread won't measurably move us farther away from that
> goal either.
> 
> It's currently under CONFIG_CIFS_EXPERIMENTAL, which would be fine if
> it actually did something. It doesn't though -- it just wakes up tasks
> that don't need to be woken up.
> 
> I have no issue with a kthread that does useful work, but why not remove
> this kthread out of the mainline code for now and just plan to put it
> back when it actually has something useful to do?
> 
> The patch that removes it will live in perpetuity in git. It'll be a
> trivial matter to revert it when you're ready to have the kthread do
> real work.

Yeah.  Currently it's useless code.  If a proper *notify implementation
for cifs still needs a thread it can be added with that implementation,
and I'm sure it'll look very different from the current one (at least
after review..)

