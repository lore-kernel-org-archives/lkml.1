Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbXJMX77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbXJMX77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 19:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbXJMX7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 19:59:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53104 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbXJMX7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 19:59:50 -0400
Subject: Re: [2.6.23.1] possible circular locking dependency detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1192317596.5625.12.camel@lappy>
References: <20071013223614.GF25076@vanheusden.com>
	 <1192317596.5625.12.camel@lappy>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 01:59:44 +0200
Message-Id: <1192319984.5625.21.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-14 at 01:19 +0200, Peter Zijlstra wrote:
> On Sun, 2007-10-14 at 00:36 +0200, Folkert van Heusden wrote:
> > I've got a deja-vu feeling for this one but in any case:
> > 

> I seems that patch hasn't made it into .23... I'll stick it in the
> lockdep tree aimed at .24.

Could you try:

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git v2.6.24-lockdep

on top of current -linus, I just pushed out the patch that should fix it:

  lockdep: per filesystem inode lock class

(still hasn't replicated though, so might take a while)



