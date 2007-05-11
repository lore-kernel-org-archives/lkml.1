Return-Path: <linux-kernel-owner+w=401wt.eu-S1763141AbXEKUId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763141AbXEKUId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbXEKUIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:08:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758798AbXEKUIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:08:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Zachary Amsden <zach@vmware.com>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 02/28]xen: Add nosegneg capability to the vsyscall page notes
In-Reply-To: Jeremy Fitzhardinge's message of  Thursday, 10 May 2007 17:06:45 -0700 <20070511001156.003375000@goop.org>
X-Shopping-List: (1) Beauteous champions
   (2) Global cancerous admonishers
   (3) Mountainous inflammation documents
Message-Id: <20070511200744.4BC1A1F8512@magilla.localdomain>
Date: Fri, 11 May 2007 13:07:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> + * It should contain:
> + *	hwcap 0 nosegneg
> + * to match the mapping of bit to name that we give here.

This comment still needs s/0/1/ to match the code.  Given that the actual
bit is now defined in the macro in another file, perhaps the comment should
say more about it than just a magic 1.


Thanks,
Roland
