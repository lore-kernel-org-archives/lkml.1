Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYHALZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYHALZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 07:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbYHALZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 07:25:42 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:43277 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709AbYHALZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 07:25:41 -0400
Message-ID: <4892F27F.3020300@s5r6.in-berlin.de>
Date: Fri, 01 Aug 2008 13:24:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Amanda McPherson <amanda@amcpherson.com>, Jiri Kosina <jkosina@suse.cz>,
       Roland Dreier <rdreier@cisco.com>, Alex Chiang <achiang@hp.com>,
       =?ISO-8859-1?Q?Jochen_Vo=DF?= <jochen.voss@googlemail.com>
Subject: Re: [PATCH] A development process document, V2 (diff from V1)
References: <20080731111443.2179bf4c@bike.lwn.net> <20080731111709.488b9fa7@bike.lwn.net>
In-Reply-To: <20080731111709.488b9fa7@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> --- a/Documentation/development-process/5.Posting
> +++ b/Documentation/development-process/5.Posting
...
> @@ -229,12 +235,18 @@ copies should go to:
...
>   - Send a copy to the relevant mailing list, or, if nothing else applies,
>     the linux-kernel list.
>  
> + - If you are fixing a bug, think about whether the fix should go into the
> +   next stable update.  If so, stable@kernel.org should get a copy of the
> +   patch.  Also add a "Cc: stable@kernel.org" to the tags within the patch

...patch after it or an equivalent was committed to Linus's tree.  Quote
the commit ID in your stable submission.  Alternatively, add a "Cc:
stable@...

> +   itself; that will cause the stable team to get a notification when your
> +   fix goes into the mainline.

Or IMO preferable:

 - If you are fixing a bug, think about whether the fix should go into
the next stable update.  If so, read ../stable_kernel_rules.txt.


(I missed the part of the thread where the addition of the -stable
bullet point was suggested, hence I may be saying something redundant
here...)
-- 
Stefan Richter
-=====-==--- =--- ----=
http://arcgraph.de/sr/
