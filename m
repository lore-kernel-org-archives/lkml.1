Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbXEIIFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbXEIIFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbXEIIAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:00:06 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:37895 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755084AbXEIIAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:00:01 -0400
X-Greylist: delayed 1216 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2007 04:00:01 EDT
Message-Id: <46419708.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 
Date: Wed, 09 May 2007 09:40:24 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Frederik Deweerdt" <deweerdt@free.fr>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, <ak@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: kmem_cache_init failure (was Re: 2.6.21-mm1)
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
 <20070508172233.GA11683@slug>
In-Reply-To: <20070508172233.GA11683@slug>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>I've bisected it down to the x86_64-mm-cpa-kerneltext.patch and the 
>
>+       if (!pte_present(*kpte))
>+               return 0;

I the most recent version of the patch I sent to Andi this line is gone (again),
as I realized it was wrong on i386 (namely for DEBUG_PAGEALLOC) and its
respective variant was superfluous on x86-64.

Jan

