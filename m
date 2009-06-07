Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZFGT27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZFGT27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 15:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZFGT2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 15:28:51 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:58077 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbZFGT2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 15:28:50 -0400
Subject: Re: [Bug #13330] nfs4 NULL pointer dereference in _nfs4_do_setlk
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rich Ercolani <rercola@acm.jhu.edu>
In-Reply-To: <D9VoutSOyXP.A.YjH.5Z7KKB@chimera>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.YjH.5Z7KKB@chimera>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 15:28:48 -0400
Message-Id: <1244402928.5278.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 5 msgs/h 2 sum rcpts/h 14 sum msgs/h 2 total rcpts 620 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: C01DAAF8D11B23F885567457FF8CF8DE6628D7A4
X-UiO-SPAM-Test: remote_host: 68.42.125.96 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 26 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 11:52 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13330
> Subject		: nfs4 NULL pointer dereference in _nfs4_do_setlk
> Submitter	: Rich Ercolani <rercola@acm.jhu.edu>
> Date		: 2009-05-17 04:44 (22 days old)
> Handled-By	: Trond Myklebust <trond.myklebust@fys.uio.no>

It should still be listed. I do believe I've finally identified the
cause, and have provided a patch, however that fix has not yet been
verified by Rich...

Cheers
  Trond

