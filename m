Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYILUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYILUF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYILUFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:05:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45119 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbYILUFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:05:19 -0400
Subject: Re: [PATCH] Audit: fix handling of 'strings' with NULL characters
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jdennis@redhat.com, sgrubb@redhat.com
In-Reply-To: <20080911170920.e88e7bc5.akpm@linux-foundation.org>
References: <1221169719.2952.14.camel@localhost.localdomain>
	 <20080911170920.e88e7bc5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 12 Sep 2008 22:03:35 +0200
Message-Id: <1221249815.2702.16.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton píše v Čt 11. 09. 2008 v 17:09 -0700:
> OK, I am now officially confused about the relationship between this
> patch, Miloslav's two patches and 2.6.27/2.6.26/2.6.25.
> 
> Think I'll go into hiding for a while - please wake us up when it's all
> sorted out.

Eric's patch ["Audit: fix handling of 'strings' with NULL characters"]
replaces my 1/2 ["audit: fix NUL handling in untrusted strings"], and
makes my 2/2 ["audit: Handle embedded NUL in TTY input auditing"]
technically unnecessary - but from the semantics POV 2/2 should still be
applied.

Either Eric's patch or my 2/2 should go to the stable releases.  The
other patches do not have to.
	Mirek

