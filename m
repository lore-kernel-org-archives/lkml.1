Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbXI3UbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbXI3UbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 16:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbXI3UbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 16:31:06 -0400
Received: from ccerelrim04.cce.hp.com ([161.114.21.25]:4443 "EHLO
	ccerelrim04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbXI3UbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 16:31:05 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Date: Sun, 30 Sep 2007 16:30:47 -0400
User-Agent: KMail/1.9.7
Cc: casey@schaufler-ca.com, torvalds@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, James Morris <jmorris@namei.org>
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org>
In-Reply-To: <20070930011618.ccb8351b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301630.48443.paul.moore@hp.com>
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.9.30.130338
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 September 2007 4:16:18 am Andrew Morton wrote:
> - hm, netlabels.  Who might be a suitable person to review that code?
>   Seems that Paul Moore is the man.  Maybe he'd be interested in taking a
>   look over it (please?)

Yep, I've been tracking Casey's work on this since the first patch and sending 
comments when appropriate.  I'm going to take a look at the latest rev of the 
patch and if anything looks awry I'll be sure to let Casey know.

The only real wart that still remains from the original patch is the code in 
smk_cipso_doi() which has a nice comment at the top saying that Paul and 
Casey need to work out an appropriate interface between NetLabel and SMACK.  
We punted on it before because SMACK's future was still a bit uncertain and 
SELinux has no need for an interface like this at present.  Now that SMACK 
looks to be queued up for 2.6.24 it's time to revisit this discussion.

-- 
paul moore
linux security @ hp
