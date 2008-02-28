Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbYB1Pct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbYB1Pct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbYB1Pcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:32:42 -0500
Received: from styx.suse.cz ([82.119.242.94]:34104 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757276AbYB1Pcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:32:41 -0500
Date: Thu, 28 Feb 2008 16:32:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: <20080228153245.GB11484@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0802281632040.3391@jikos.suse.cz>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
 <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
 <20080228102649.071572700FD@magilla.localdomain> <Pine.LNX.4.64.0802281238550.3391@jikos.suse.cz>
 <20080228153245.GB11484@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Oleg Nesterov wrote:

> This is different, you can try this trivial program,
> 
> 	int main(int argc, char **argv)
> 	{
> 		kill(getpid(), SIGSTOP);
> 		printf("I'm running, SIGSTOP doesn't really work with strace.\n");
> 		return 0;
> 	}

Yes, I have meanwhile (to my surprise) found out that it is even 
documented in the strace manpage ...

Strange thing, though.

-- 
Jiri Kosina
