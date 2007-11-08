Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbXKHWJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbXKHWJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759452AbXKHWJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:09:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759203AbXKHWJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:09:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: akpm@linux-foundation.org
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, drepper@redhat.com, mingo@elte.hu
Subject: Re: [patch 2/2] clone: prepare to recycle CLONE_DETACHED and CLONE_STOPPED
In-Reply-To: akpm@linux-foundation.org's message of  Thursday, 8 November 2007 13:31:43 -0800 <200711082131.lA8LVhnk015137@imap1.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <200711082131.lA8LVhnk015137@imap1.linux-foundation.org>
X-Windows: simplicity made complex.
Message-Id: <20071108220911.DB98C4D0564@magilla.localdomain>
Date: Thu,  8 Nov 2007 14:09:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CLONE_STOPPED was previously used by some NTPL versions when under
thread_db (i.e. only when being actively debugged by gdb), but not for a
long time now, and it never worked reliably when it was used.
Removing it seems fine to me.


Thanks,
Roland
