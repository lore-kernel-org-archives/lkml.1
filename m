Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbXINQiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbXINQiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbXINQiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:38:09 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:63300 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950AbXINQiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:38:08 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Brent Casavant <bcasavan@sgi.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
References: <20070912144128.D5573@pkunk.americas.sgi.com>
	<jetzpza7ci.fsf@sykes.suse.de>
	<20070912172519.N5573@pkunk.americas.sgi.com>
	<20070912224955.GC8181@ftp.linux.org.uk>
	<20070912180937.Y5573@pkunk.americas.sgi.com>
Date: Fri, 14 Sep 2007 18:37:54 +0200
In-Reply-To: <20070912180937.Y5573@pkunk.americas.sgi.com> (Brent Casavant's
	message of "Wed, 12 Sep 2007 18:27:52 -0500 (CDT)")
Message-ID: <87r6l1qk2l.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brent Casavant <bcasavan@sgi.com> writes:

> My (limited) understanding of ptrace is that a parent-child
> relationship is needed between the tracing process and the traced
> process (at least that's what I gather from the man page).  This
> does give cause for concern, and I might have to see what can be
> done to alleviate this concern.  I fully realize that making this
> design completely unassilable is a fools errand, but closing off
> as many attack vectors as possible seems prudent.

No relationship needed:

strace -p <pid>

MfG
        Goswin
