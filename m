Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbXICIaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbXICIaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbXICIaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:30:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:2790 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXICIaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tNZ8za6ds2AZuxXHcQ3WsK4YdksH8qWZQHUmn7VPLoNu6NE+uo3xnXorFQHAxpzbY1KjKU4Z1auJitIc4bIpxD33ZaKxw5n7jWR/U9a8EYsQ7hsMm3ATp4OHRTBXJz8F6FDI1ZNv/GiXJnzN5UWyhLf6irX/ppr1Lv9Qbux6GFc=
Message-ID: <46DBC605.9040401@gmail.com>
Date: Mon, 03 Sep 2007 17:29:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: postfail@hushmail.com
CC: brandon@ifup.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH resubmit] /drivers/ata ioremap returncode check
References: <648310.70195.qm@web44903.mail.sp1.yahoo.com>
In-Reply-To: <648310.70195.qm@web44903.mail.sp1.yahoo.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Thompson wrote:
> Patchset against 2.6.23-rc3.  corrects missing ioremap return 
> checks, resending after fixing for documentation making changes suggested...
> 
> As for suggestions, I did fix the {} that weren't needed.  I did not add in a
> "printk" err or warn statement as the rest of the module does not contain these
> messages.  When auditing (as I am for ioremap checking here) I am attempting
> to keep changes "in the style of their surroundings".  Otherwise it's massive
> scope screep on these patches.
>  
> Signed-off-by: Scott Thompson <postfail <at> hushmail.com>

Acked-by: Tejun Heo <htejun@gmail.com>

It would be better to start the subject line with pata_ixp4xx_cf: but
maybe Jeff can fix it up while applying.

Thanks.

-- 
tejun
