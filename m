Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbYLDA4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbYLDA4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759957AbYLDAzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:55:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759313AbYLDAzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:55:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/linus
Cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 6/9] Use virtual debug registers in process/thread
 handling code
In-Reply-To: Alan Stern's message of  Saturday, 18 October 2008 11:34:56 -0400 <Pine.LNX.4.44L0.0810181123220.1469-100000@netrider.rowland.org>
References: <20081018000829.519111544CB@magilla.localdomain>
	<Pine.LNX.4.44L0.0810181123220.1469-100000@netrider.rowland.org>
X-Windows: simplicity made complex.
Message-Id: <20081204005203.9CCD5FC3C8@magilla.sf.frob.com>
Date: Tue,  2 Dec 2008 20:54:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hmm.  The 64-bit version of __switch_to does the current change much
> > earlier, before __switch_to_xtra and math_state_restore.  I wonder if the
> > 32-bit version could change to match.  I can't see what in __switch_to_xtra
> > would care either way, though I may be overlooking something.  Ingo?
> 
> Would it be better to move __switch_to_xtra down below the change to 
> current, rather than moving the change to current up above 
> __switch_to_xtra?

I can't see that anything else in __switch_to_xtra cares either way.


Thanks,
Roland

