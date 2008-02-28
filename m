Return-Path: <linux-kernel-owner+w=401wt.eu-S1765489AbYB1UBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765489AbYB1UBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765105AbYB1T5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:57:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37431 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765080AbYB1T5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:57:41 -0500
Message-ID: <47C71233.4050705@garzik.org>
Date: Thu, 28 Feb 2008 14:57:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: git@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: 'git gc' always run, on old kernel repo?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to apply a kernel patch diff'd against an older kernel, I ran

	git checkout -b tmp v2.6.23
	git-am --signoff --utf8 /g/tmp/mbox

The patch applied successfully, but each time I run this, it starts an 
automated 'git gc' run...  even if there is nothing useful to gc:

> [jgarzik@pretzel netdev-2.6]$ git-am --signoff --utf8 /g/tmp/mbox 
> Applying Add support for HT1100 SATA controller - sent from evolution
> Auto packing your repository for optimum performance. You may also
> run "git gc" manually. See "git help gc" for more information.
> Counting objects: 1, done.
> Writing objects: 100% (1/1), done.
> Total 1 (delta 0), reused 0 (delta 0)
> warning: There are too many unreachable loose objects; run 'git prune' to remove them.

IMO there is a broken hueristic in there somewhere...  I regularly run 
'git gc' on my repos...

	Jeff


