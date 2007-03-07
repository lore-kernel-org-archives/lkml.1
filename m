Return-Path: <linux-kernel-owner+w=401wt.eu-S1161240AbXCGDmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161240AbXCGDmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 22:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161242AbXCGDmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 22:42:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161240AbXCGDmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 22:42:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: bryan.wu@analog.com
X-Fcc: ~/Mail/utrace
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] utrace: nommu fixup support utrace
In-Reply-To: Wu, Bryan's message of  Tuesday, 6 March 2007 15:25:27 +0800 <1173165927.17134.5.camel@roc-desktop>
X-Shopping-List: (1) Inglorious goats
   (2) Intrusive capricious skis
   (3) Preposterous turkey opinions
   (4) Extemporaneous televangelist dividers
Message-Id: <20070307034216.472921801C4@magilla.sf.frob.com>
Date: Tue,  6 Mar 2007 19:42:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That old ptrace check seems pretty questionable to me.  I think what you
want is for the nommu world's get_user_pages/access_process_vm when called
with force=1,write=1 on a read-only MAP_PRIVATE page to do something more
morally similar to the mmu world's COW than it does now.


Thanks,
Roland
