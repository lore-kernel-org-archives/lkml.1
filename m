Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbXD1JAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbXD1JAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXD1JAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:00:39 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:35765 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbXD1JAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:00:32 -0400
From: Oliver Neukum <oliver@neukum.org>
To: David Lang <david.lang@digitalinsight.com>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 08:58:25 +0200
User-Agent: KMail/1.9.1
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177718250.4737.222.camel@nigel.suspend2.net> <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704280858.26615.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 28. April 2007 01:50 schrieb David Lang:
> 3. make mounted filesystems read-only (possibly with snapshot/checkpoint)
> 4. unpause
> 5. save image (with full userspace available, including network)
> 6. shutdown system (throw away all userspace memory, no need to do graceful
>     shutdown or nice kill signals, revert filesystem to snapshot/checkpoint if
>     needed)

And then you'll have people wonder why the server which sent out all
those files has no log entries. You'd have to selectively unfreeze user
space, which is a cure worse than the desease.

Simply throwing away user space work is a bug. And no, you cannot say that
it'll be redone away, as you are throwing away accepted input, too.

	Regards
		Oliver
