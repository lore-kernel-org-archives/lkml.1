Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbXHRXNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbXHRXNQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 19:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbXHRXNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 19:13:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088AbXHRXND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 19:13:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] exec: simplify the new ->sighand allocation
In-Reply-To: Oleg Nesterov's message of  Saturday, 18 August 2007 21:39:50 +0400 <20070818173950.GA212@tv-sign.ru>
Emacs: no job too big... no job.
Message-Id: <20070818231259.1A9834D05C6@magilla.localdomain>
Date: Sat, 18 Aug 2007 16:12:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 	- ENOMEM still can happen after de_thread(), ->sighand is not the last
> 	  object we have to allocate

As long as this is true, I think it's the incontrovertible argument there
is no reason not to simplify it.  (Not that I don't also agree with your
other reasons).


Thanks,
Roland
