Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbXGKF0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbXGKF0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbXGKF0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:26:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbXGKF0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:26:04 -0400
Date: Tue, 10 Jul 2007 22:25:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: miklos@szeredi.hu, netdev@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] rewrite AF_UNIX garbage collector, fixes race
Message-Id: <20070710222511.bcc87825.akpm@linux-foundation.org>
In-Reply-To: <20070710.221224.48800386.davem@davemloft.net>
References: <E1I61UT-0006Gk-00@dorka.pomaz.szeredi.hu>
	<20070710.221224.48800386.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 22:12:24 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> But myself, nor any other developers, are going to review your work
> any faster if you do things like try to slip things in behind the
> maintainer's back as you attempted to do yesterday by asking Andrew to
> put your AF_UNIX garbage collector rewrite directly into his -mm tree.

mmm...  I didn't see it as a slip-behind-the-back thing.  More a "park it
in -mm for a bit of concurrent testing and so it doesn't get lost and so I
don't have to worry about it any more" thing.  Plenty of that goes on.

It wasn't done in a very subtle way though ;)
