Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYFQG0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYFQG0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 02:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYFQG0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 02:26:05 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34408 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbYFQG0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 02:26:04 -0400
Message-Id: <1213682570.13708.1258839317@webmail.messagingengine.com>
X-Sasl-Enc: jqNTBVF55AcTOY8JtJpAMvtwsJ/Gm4vUyZy+YyccRyzG 1213682570
From: "Bron Gondwana" <brong@fastmail.fm>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: " Rob Mueller" <robm@fastmail.fm>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1213682410.13174.1258837181@webmail.messagingengine.com>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <1213682410.13174.1258837181@webmail.messagingengine.com>
Date: Tue, 17 Jun 2008 16:02:50 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Jun 2008 16:00:10 +1000, "Bron Gondwana" <brong@fastmail.fm> said:
> I apologise for the length of the attached C program.  I tried
> to make it shorter, but kept not tickling the bug.  There's also
> another advantage of keeping it like this - it closely mirrors the
> Cyrus behaviour, to the point where the output is a valid skiplist
> file.

And I appear to have sent the one without the usage comments at the top.
Here they are:

 * USAGE:
 *    $ gcc -g maptest.c
 *    $ ./a.out z
 *    $ hexdump -C z.NEW
 *
 * Notice the block of zero byte records appearing within
 * the output.
 *
 * Run with a second argument:
 *
 *    $ ./a.out z 1
 *    $ hexdump -C z.NEW
 *
 * No more zeros!

Bron.
-- 
  Bron Gondwana
  brong@fastmail.fm

