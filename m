Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYAMTMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYAMTMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 14:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYAMTMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 14:12:32 -0500
Received: from mail.fieldses.org ([66.93.2.214]:42801 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbYAMTMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 14:12:31 -0500
Date: Sun, 13 Jan 2008 14:12:03 -0500
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jlayton@redhat.com>, akpm@linux-foundation.org, neilb@suse.de,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] NLM: Initialize completion variable in lockd_up
Message-ID: <20080113191203.GA24812@fieldses.org>
References: <1199820798-5289-1-git-send-email-jlayton@redhat.com> <1199820798-5289-2-git-send-email-jlayton@redhat.com> <1199820798-5289-3-git-send-email-jlayton@redhat.com> <1199820798-5289-4-git-send-email-jlayton@redhat.com> <20080109173542.GA30523@infradead.org> <20080113082718.396890f7@tleilax.poochiereds.net> <20080113181743.GA20219@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113181743.GA20219@infradead.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 06:17:43PM +0000, Christoph Hellwig wrote:
> Btw, lockd() takes BKL just after starting up and only implicitly drops
> it when blocking.  This seems very dangerous to me and badly wants
> updating to some real locking scheme..

Yep.

--b.
