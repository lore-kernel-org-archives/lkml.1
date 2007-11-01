Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbXKAS6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbXKAS6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXKAS6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:58:06 -0400
Received: from THUNK.ORG ([69.25.196.29]:56737 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbXKAS6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:58:05 -0400
Date: Thu, 1 Nov 2007 14:57:10 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch] PID namespace design bug, workaround
Message-ID: <20071101185710.GA2387@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Ulrich Drepper <drepper@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
References: <20071101144307.GA29566@elte.hu> <4729E86A.9090705@redhat.com> <20071101150537.GC4044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101150537.GC4044@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 04:05:37PM +0100, Ingo Molnar wrote:
> +	if (clone_flags & CLONE_NEWPID)
> +		return -ENOSYS;

I'd use EINVAL instead of ENOSYS...

						- Ted
