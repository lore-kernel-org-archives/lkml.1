Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbYAPHJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbYAPHJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 02:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYAPHJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 02:09:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:22874 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYAPHJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 02:09:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=N5UIipwzLvLZ2uernS7GST5aHcKdEaGRxUhmW3M3T/MVgZixBtrNztJspKGiiil8Y1JlQt6kRTEnEbhItYsIs2AYI3lBbBPptx/oOmIhTMLh0tAAGsFe63o74HiCEXJCROylppZ+/yOBbur65FqQpGUg5lMIsnoxQCSmNhjdzxo=
Message-ID: <e9c3a7c20801152309g28493cecx57efa8a8bba2fd21@mail.gmail.com>
Date: Wed, 16 Jan 2008 00:09:31 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "dean gaudet" <dean@arctic.org>
Subject: Re: [PATCH 001 of 6] md: Fix an occasional deadlock in raid5
Cc: "Andrew Morton" <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.999999.0801152157310.9578@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080114123726.19968.patches@notabene>
	 <1080114014525.20337@suse.de>
	 <alpine.DEB.0.999999.0801152059170.9578@twinlark.arctic.org>
	 <20080115215425.b1fcba31.akpm@linux-foundation.org>
	 <alpine.DEB.0.999999.0801152157310.9578@twinlark.arctic.org>
X-Google-Sender-Auth: cf028bc427517752
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> heheh.
>
> it's really easy to reproduce the hang without the patch -- i could
> hang the box in under 20 min on 2.6.22+ w/XFS and raid5 on 7x750GB.
> i'll try with ext3... Dan's experiences suggest it won't happen with ext3
> (or is even more rare), which would explain why this has is overall a
> rare problem.
>

Hmmm... how rare?

http://marc.info/?l=linux-kernel&m=119461747005776&w=2

There is nothing specific that prevents other filesystems from hitting
it, perhaps XFS is just better at submitting large i/o's.  -stable
should get some kind of treatment.  I'll take altered performance over
a hung system.

--
Dan
