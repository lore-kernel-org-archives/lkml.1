Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYKFEZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYKFEZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 23:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYKFEZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 23:25:05 -0500
Received: from mail.ocs.com.au ([202.134.241.204]:15259 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbYKFEZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 23:25:04 -0500
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2008 23:25:03 EST
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-16) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] scripts: script from kerneloops.org to pretty print oops dumps 
In-reply-to: Your message of "Wed, 05 Nov 2008 19:07:26 -0800."
             <20081105190726.31952581@infradead.org> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 06 Nov 2008 15:15:22 +1100
Message-ID: <11403.1225944922@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven (on Wed, 5 Nov 2008 19:07:26 -0800) wrote:
>I had this script lying around (used on kerneloops.org in a slightly modified form, 
>where I use a database as input rather than stdin). I think it's a useful tool,
>at least I find it extremely useful in turning oopses into an "oh duh yes there"
>experience...
>
>Caveats:
>* It only works for oopses not-in-modules
>* It only works nicely for kernels compiled with CONFIG_DEBUG_INFO
>* It's not very fast.

Another caveat: "if ($_ =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/)" means that
it only works on x86_32.

