Return-Path: <linux-kernel-owner+w=401wt.eu-S1765450AbZLQWLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765450AbZLQWLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:11:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765349AbZLQWLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:11:05 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:45720 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760090AbZLQWLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:11:04 -0500
Date: Thu, 17 Dec 2009 23:09:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, mmarek@suse.cz, tglx@linutronix.de,
       mhiramat@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] Makefile: set LC_CTYPE, LC_COLLATE,
	LC_NUMERIC to C
Message-ID: <20091217220951.GB4236@merkur.ravnborg.org>
References: <4B2A1761.4070904@suse.cz> <tip-c051346b7db27aaf674b8f3b4955240580b2a58a@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-c051346b7db27aaf674b8f3b4955240580b2a58a@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 04:18:35PM +0000, tip-bot for H. Peter Anvin wrote:
> Commit-ID:  c051346b7db27aaf674b8f3b4955240580b2a58a
> Gitweb:     http://git.kernel.org/tip/c051346b7db27aaf674b8f3b4955240580b2a58a
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Thu, 17 Dec 2009 06:56:11 -0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 17 Dec 2009 07:03:21 -0800
> 
> Makefile: set LC_CTYPE, LC_COLLATE, LC_NUMERIC to C
> 
> There are a number of common Unix constructs like character ranges in
> grep/sed/awk which don't work as expected with LC_COLLATE set to other
> than C.  Similarly, set LC_CTYPE and LC_NUMERIC to C to avoid other
> nasty surprises.
> 
> In order to make sure these actually take effect we also have to
> clear LC_ALL.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Acked-by: Michal Marek <mmarek@sues.cz>
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> Acked-by: Roland Dreier <rdreier@cisco.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> LKML-Reference: <4B2A1761.4070904@suse.cz>

This is IMO -next fodder and not urgent stuff.
In the distant past something similar caused us troubles.

I assume that the patch posted by Roland fixes
the relevant troubles with the awk script and that
this patch is just for consistency.
So in other words stuff for -next and not -rc1.

Anyway - just MHO.

	Sam
