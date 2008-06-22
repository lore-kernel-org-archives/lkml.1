Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYFVWJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYFVWJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbYFVWJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:09:48 -0400
Received: from bu3sch.de ([62.75.166.246]:52227 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbYFVWJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:09:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Oops when using growisofs
Date: Mon, 23 Jun 2008 00:09:45 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>
References: <200806221818.24372.mb@bu3sch.de> <200806222322.05706.arnd@arndb.de> <200806222331.29691.arnd@arndb.de>
In-Reply-To: <200806222331.29691.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806230009.45950.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 June 2008 23:31:29 Arnd Bergmann wrote:
> On Sunday 22 June 2008, Arnd Bergmann wrote:
> 
> > Evidently, alloc_page_buffers got an out of memory condition, which was not caught
> > by create_empty_buffers. No idea how it should be handled, but the fact that it's
> > not looks like a bug to me ;-).
> 
> Oh, btw: http://www.kerneloops.org/search.php?search=create_empty_buffers&btnG=Function+Search
> finds 15 more instances of the same bug (and one other bug), across lots of
> kernel versions and architectures. The bug has been there since we started
> using git.

So, ehm. Maybe some debugging code should be added??
We could at least add code that prevents a crash and adds WARN_ONs.


-- 
Greetings Michael.
