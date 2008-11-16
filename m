Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbYKPQ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbYKPQ4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYKPQ42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:56:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:35546 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYKPQ41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:56:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LlMVvJq29lHfmVTWqOdDNHzrIzJxOMbcOX0ihGQtkW/6sGXKfwElOEZCBOavTHvQcZ
         g5mScebuO1v2B/Z3R76M6Fr+xdKox+j1fl8FWdjpcAHCmfbSHGoY+uku9hoF8+5UskHT
         +9zMJKiPJvt8ROEkb6i7XZHmCAwYaAuMKxtjI=
Subject: Re: ACPI: EC: GPE storm detected, transactions will use polling
 mode
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
In-Reply-To: <491FECAE.6050005@gmail.com>
References: <1226722577.3104.4.camel@LiNuX> <491EBB2D.70106@tuffmail.co.uk>
	 <dd18b0c30811151039i4a5e295euc4aaa52382d47bb1@mail.gmail.com>
	 <200811152019.31744.rjw@sisk.pl> <1226817681.3133.7.camel@LiNuX>
	 <491FECAE.6050005@gmail.com>
Content-Type: text/plain
Date: Sun, 16 Nov 2008 08:56:20 -0800
Message-Id: <1226854580.3385.9.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-16 at 12:49 +0300, Alexey Starikovskiy wrote:
> Justin P. Mattock wrote:
> > Well; reverting:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=06cf7d3c7af902939cd1754abcafb2464060cba8
> > is keeping the system from having a gpe storm
> > (for at least four hours now);
> > haven't had a chance to drain the battery and see
> > the affects from that scenario.
> >
> >   
> Justin, by decreasing threshold, we just change how often _detection_ of 
> the storm fires, not the storm itself.
> 
> Regards,
> Alex.

So increasing the threshold was a good thing
(reveal the problem, not hide the problem);
As for the cause itself, is there any tool
that can be used to at-least gain any info
on this? 
>From looking at the situation
from here with a macbook, the interaction with the battery
seems to be the cause, but then on other notebooks it's 
another situation.(making this problem very intricate).
Anyways I don't have a problem changing the threshold
or using a boot param, to keep this in somewhat control
for the time being until there is a solution.
let me know how I can help.
regards;

-- 
Justin P. Mattock <justinmattock@gmail.com>

