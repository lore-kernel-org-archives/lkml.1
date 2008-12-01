Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYLAARa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYLAARa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYLAARV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:17:21 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:60253 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbYLAARU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:17:20 -0500
Subject: Re: [PATCH 0/3] NFS regression in 2.6.26?, "task blocked for more
 than 120 seconds"
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-nfs@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
       linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1227737539.31008.2.camel@localhost.localdomain>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
	 <1227621434.7057.33.camel@heimdal.trondhjem.org>
	 <1227621877.9425.102.camel@zakaz.uk.xensource.com>
	 <1227737539.31008.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 30 Nov 2008 19:17:11 -0500
Message-Id: <1228090631.7112.11.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 6AAB1633FD053F3A56075AC9FF29E44E94BAD08C
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 226 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you see if the following 3 patches help? They're against 2.6.28-rc6,
but afaics the problems are pretty much the same on 2.6.26.

Cheers
  Trond

