Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYLDAog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYLDAog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYLDAo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:44:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbYLDAo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:44:26 -0500
Date: Wed, 3 Dec 2008 16:44:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "David S. Miller" <davem@davemloft.net>,
       Gaudenz Steinlin <gaudenz@debian.org>
Subject: Re: [Bug #12158] commit b1ee26b freezes system on switching from X
 to text console
In-Reply-To: <bfPM5B8Tx2B.A.8DH.voxNJB@chimera>
Message-ID: <alpine.LFD.2.00.0812031642280.3256@nehalem.linux-foundation.org>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera> <bfPM5B8Tx2B.A.8DH.voxNJB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Dec 2008, Rafael J. Wysocki wrote:
>
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12158
> Subject		: commit b1ee26b freezes system on switching from X to text console
> Submitter	: Gaudenz Steinlin <gaudenz@debian.org>
> Date		: 2008-11-25 19:44 (9 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1ee26bab14886350ba12a5c10cbc0696ac679bf
> References	: http://marc.info/?l=linux-kernel&m=122764344231140&w=4
> Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>

I think we're assuming that this already got fixed by commit 
c4c6fa9891f3d1bcaae4f39fb751d5302965b566 ("radeonfb: fix problem with 
color expansion & alignment").

Gaudenz?

			Linus
