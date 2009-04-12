Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbZDLRxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbZDLRxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZDLRxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:53:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41416 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZDLRxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VR45dKMhJi7ujE1TbRtX0rrhCiHE3KKZkubFP6Qt2lwfVCet5q9ycdadYQ+WhS07Iw
         1RNLM26j9UUYLfdvyIkSfcu75xa+nyO1dMWvMVZBrpMWdlm2fDYe2177xuhRxKWE16P/
         ifOEm/GNyCn08KYaadaC7dC7egQMTj0Jk6atM=
Date: Sun, 12 Apr 2009 21:53:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, tglx@linutronix.de, xemul@openvz.org, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, macro@linux-mips.org, andi@firstfloor.org
Subject: Re: [rfc 1/4] x86: irq.c - tiny cleanup
Message-ID: <20090412175304.GC6942@lenovo>
References: <20090412164738.967602112@openvz.org> <20090412165058.277579847@openvz.org> <20090412172536.GB26459@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412172536.GB26459@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Apr 12, 2009 at 07:25:36PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| 
| > Impact: cleanup
| > 
| > 1) guard ack_bad_irq with printk_ratelimit since there is no
| >    guarantee we will not be flooded one day
| > 2) use pr_emerg helper
| > 
... 
| Btw, this is not so theoretical - in the past i've had bugs where a 
| flood of these messages made the system unusable. (granted, it would 
| have been unusable even with rate-limiting - but it's still nice to 
| have a throttle in place for something like this.)
| 
| 	Ingo
| 

I bet the only benefit is that a user will have
some time to pull out camera and snap screen
before it's scrolled with bad irq messages :)

        Cyrill
