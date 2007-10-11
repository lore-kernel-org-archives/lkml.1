Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbXJKVWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbXJKVWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXJKVWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:22:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40182 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbXJKVWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:22:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470E93D3.5050707@s5r6.in-berlin.de>
Date: Thu, 11 Oct 2007 23:21:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation/patch-tags v3
References: <30616.1192133818@lwn.net> <1192135811.7899.25.camel@heimdal.trondhjem.org>
In-Reply-To: <1192135811.7899.25.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> Does 'Reviewed-by' also imply 'Signed-off-by'?

Does a technical review include a review of licensing and copyright
issues?  (It doesn't seem to be a big issue though if the submitter
signed off on it, like he should.)

> In other words, who is actually supposed to add this tag?
> 
> Is it the reviewer who passes on an officially 'reviewed' patch to the
> maintainer, or is it the patch author him/herself who is responsible for
> soliciting reviews and adding the tag?

Anybody in the patch forwarding chain (author, maintainers... usually
the latter) can add Acked-by and Tested-by, based on incoming feedback.
The feedback may have explicitly stated an Acked-by or Tested-by or may
have said something equivalent.  (In case of Tested-by, an appropriate
description of how was tested should have been sent.  An explicit
Tested-by from the tester himself is moot then.)

Reviewed-by is a different beast.  If Jon's definition of Reviewed-by
(or another definition) is "officially" adopted, people in the patch
forwarding chain should only add this tag if the reviewer sent it
explicitly in his response.  Unlike with Acked-by and Tested-by, we must
not guess whether a reviewer wants to have his Reviewed-by added.

[...]
>> + (c) While there may be things that could be improved with this submission,
>> +     I believe that it is, at this time, (1) a worthwhile modification to
>> +     the kernel, and (2) free of known issues which would argue against its
>> +     inclusion.
>> +
>> + (d) While I have reviewed the patch and believe it to be sound, I do not
>> +     (unless explicitly stated elsewhere) make any warranties or guarantees
>> +     that it will achieve its stated purpose or function properly in any
>> +     given situation.
> 
> I'm confused about how to reconcile (c) and (d) here. If you are not
> sure about whether or not the patch will achieve its stated purpose, why
> would you be arguing that it is a worthwhile modification?

Being sure of something and making guarantees are different things.
-- 
Stefan Richter
-=====-=-=== =-=- -=-==
http://arcgraph.de/sr/
