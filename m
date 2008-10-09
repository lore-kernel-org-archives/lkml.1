Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYJIA1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYJIA1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYJIA1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:27:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41276 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYJIA1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:27:37 -0400
Subject: mISDN didn't define af_family_key_strings et al.
From: Eric Paris <eparis@redhat.com>
To: kkeil@suse.de
Cc: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Content-Type: text/plain
Date: Wed, 08 Oct 2008 20:27:29 -0400
Message-Id: <1223512049.2952.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see that recently AF_ISDN was added to the kernel but I don't see them
having updated af_family_key_strings[] found in net/core/sock.c.  I'm
adding a new one myself and caught a NULL entry toward the end of the
array.  My assumption is that isdn is using the sk_lock-AF_MAX entry
instead of their own.

As an aside it was nice having such a clean explosion when I didn't add
my own.  Are the AF_MAX entries in those arrays really needed?  If we
dropped it altogether would others (like myself and the isdn people) who
forgot to add their own get nice explosions with no other problems?

-Eric

