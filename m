Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbYKPJtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbYKPJtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYKPJtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:49:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:36549 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbYKPJtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aBxsem65+bcq8Dx6NhDNkHB0zsgAa31lhaJM4//Xvsy2Nr1nDXPk8zSjpP91FouRjt
         iFkyI88djpPjjC4fX4T35RCnKwLuefAs/vq617KCFgPPXNcgQISYKmhpKUEFEmbI/0gF
         pnZjW/Ttl836MswIj3BohkJxx50OHLDqTWHt8=
Message-ID: <491FECAE.6050005@gmail.com>
Date: Sun, 16 Nov 2008 12:49:34 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: ACPI: EC: GPE storm detected, transactions will use polling mode
References: <1226722577.3104.4.camel@LiNuX> <491EBB2D.70106@tuffmail.co.uk>	 <dd18b0c30811151039i4a5e295euc4aaa52382d47bb1@mail.gmail.com>	 <200811152019.31744.rjw@sisk.pl> <1226817681.3133.7.camel@LiNuX>
In-Reply-To: <1226817681.3133.7.camel@LiNuX>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> Well; reverting:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=06cf7d3c7af902939cd1754abcafb2464060cba8
> is keeping the system from having a gpe storm
> (for at least four hours now);
> haven't had a chance to drain the battery and see
> the affects from that scenario.
>
>   
Justin, by decreasing threshold, we just change how often _detection_ of 
the storm fires, not the storm itself.

Regards,
Alex.
