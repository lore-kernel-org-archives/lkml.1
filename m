Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbYB1QNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbYB1QNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760115AbYB1QNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:13:25 -0500
Received: from styx.suse.cz ([82.119.242.94]:35450 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760056AbYB1QNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:13:24 -0500
Date: Thu, 28 Feb 2008 17:13:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: <20080228160834.GA11510@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0802281711500.3391@jikos.suse.cz>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
 <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
 <20080228102649.071572700FD@magilla.localdomain> <20080228153043.GA11484@tv-sign.ru>
 <Pine.LNX.4.64.0802281633540.3391@jikos.suse.cz> <20080228160834.GA11510@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Oleg Nesterov wrote:

> Hmm... Can't we make a simpler patch for the start? See below.
> We can notify the parent earlier, before waking the TASK_STOPPED
> child. This should fix this race, no?

Yes, this looks also like a correct fix to me (haven't tried to run the 
actual test yet, but 'obviously' it should close the race).

Thanks,

-- 
Jiri Kosina
SUSE Labs
