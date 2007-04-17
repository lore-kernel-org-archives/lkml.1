Return-Path: <linux-kernel-owner+w=401wt.eu-S1031222AbXDQRHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031222AbXDQRHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031221AbXDQRHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:07:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:59348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031222AbXDQRHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:07:35 -0400
To: Karl MacMillan <kmacmill@redhat.com>
Cc: David Safford <safford@watson.ibm.com>, James Morris <jmorris@namei.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
References: <20070416213350.GB4030@suse.de>
	<Line.LNX.4.64.0704161846110.13905@d.namei>
	<1176822230.3366.65.camel@localhost.localdomain>
	<1176825641.5946.41.camel@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Apr 2007 20:05:29 +0200
In-Reply-To: <1176825641.5946.41.camel@localhost.localdomain>
Message-ID: <p73abx66fme.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karl MacMillan <kmacmill@redhat.com> writes:
 
> No - the real fix is to change the applications or to run under a policy
> that confines all applications. Most of the problems with resolv.conf,
> mtab, etc. stem from admin processes (e.g., editors or shell scripts)
> all running under the same unconfined domain.
> 
> In some cases applications need modification as only the application has
> enough information to determine the correct label. Usually this means
> preserving labels from input files or separating the output into
> distinct directories so type transitions or label inheritance will work.
> 
> restorecond is just a hack not a requirement or a sign that something is
> wrong with the model. That is why it is a userspace application and not
> integrated into the kernel mechanism.

You nicely show one of the major disadvantages of the label model vs the path 
model here: it requires modification of a lot of applications. 

Maybe John can borrow your statement for new versions of his FAQ @)

-Andi
