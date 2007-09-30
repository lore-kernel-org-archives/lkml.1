Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbXI3RkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbXI3RkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbXI3RkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:40:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:46274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617AbXI3RkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:40:01 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Joshua Brindle <method@manicmethod.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Date: Sun, 30 Sep 2007 19:39:57 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Paul Moore <paul.moore@hp.com>
References: <46FEEBD4.5050401@schaufler-ca.com> <200709301042.26473.ak@suse.de> <46FFDCEF.20404@manicmethod.com>
In-Reply-To: <46FFDCEF.20404@manicmethod.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301939.57542.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> CIPSO is supported on SELinux as well.

That's no reason to extend that design mistake.

> It certainly has uses where IPSec  
> is excessive. One example is someone I talked to recently that basically 
> has a set of blade systems connected with a high speed backplane that 
> looks like a network interface. CIPSO is useful in this case because 
> they can't afford the overhead of IPSec but need to transfer the level 
> of the connection to the other machines. The backplane is a trusted 
> network and that isn't a dangerous assumption in this case.

If one of the boxes gets broken in all are compromised this way? 

> CIPSO also lets systems like SELinux and SMACK talk to other trusted 
> systems (eg., trusted solaris) in a way they understand. 

Perhaps, but is the result secure? I have severe doubts.

> I don't  
> regularly support CIPSO as I believe IPSec labeling is more useful in 
> more situations but that doesn't mean CIPSO is never useful.

Security that isn't secure is not really useful. You might as well not
bother.

-Andi

