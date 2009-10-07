Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbZJGKS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbZJGKS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbZJGKS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:18:26 -0400
Received: from khc.piap.pl ([195.187.100.11]:52951 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757535AbZJGKSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:18:25 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andy Whitcroft <apw@canonical.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	<1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	<1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	<4AB86ED1.1040200@cn.fujitsu.com> <20090930152708.GD2957@shadowen.org>
	<1254406711.18167.88.camel@desktop>
	<m33a5ww8kn.fsf@intrepid.localdomain>
	<1254887534.18167.253.camel@desktop>
Date: Wed, 07 Oct 2009 12:17:46 +0200
In-Reply-To: <1254887534.18167.253.camel@desktop> (Daniel Walker's message of
	"Tue, 06 Oct 2009 20:52:14 -0700")
Message-ID: <m3hbubv779.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker <dwalker@fifo99.com> writes:

> This thread is specifically about checkpatch errors .. checkpatch
> warnings can be ignored, but errors you can't usually ignore..

Of course I can and do :-)

> If your
> ignoring errors then either checkpatch is producing bogus output that
> needs to be corrected, or it's something you really should fix..

Neither.
But unfortunately I don't have examples handy.

My POV must be a bit different: I treat errors like another class of
warnings (perhaps more important that "mere" warnings but still not
authoritative).

This is BTW precisely what is needed WRT to that chunk of code
(include/trace/events/ext4.h, I assume checkpatch produces "error"
there) - though I think I'd format it a bit differently.


Perhaps checkpatch should stop producing "errors" (which are meaningless
as checkpatch has no authority to veto anything - a human has to decide)
and should simply give some severity code?
OTOH I ignore error/warning distinction completely, perhaps the
distinction is bogus? Not sure.
-- 
Krzysztof Halasa
