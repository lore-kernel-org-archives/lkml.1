Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbXHXHeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbXHXHeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXHXHeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:34:12 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:24469 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbXHXHeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:34:11 -0400
Subject: Re: [PATCH] s390 appldata_base: Remove module_exit function and
	modular stuff
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Satyam Sharma <satyam@infradead.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0708240419120.14807@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0708230706570.2049@enigma.security.iitk.ac.in >
	 <alpine.LFD.0.999.0708230746450.2049@enigma.security.iitk.ac.in>
	 <1187866866.6599.6.camel@localhost>
	 <alpine.LFD.0.999.0708240419120.14807@enigma.security.iitk.ac.in>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 24 Aug 2007 09:37:55 +0200
Message-Id: <1187941075.13076.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 04:21 +0530, Satyam Sharma wrote:
> > I has been a module once for debugging purposes That the module_exit
> > function still exists is "historical". We can remove it since it is dead
> > code.
> 
> Thanks, fair enough. Does this mean you're acking them -- I'd prefer both
> the patches to be applied separately. Rationale: we should still fix the
> appldata_exit() related oops _before_ removing it so that in future if
> this needs to be made modular for debugging purpose again, just the
> removal patch can be reverted, but the oops would still be fixed in the
> commit before it.

ACK, the patches are fine.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


