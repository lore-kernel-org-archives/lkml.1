Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXD2Aag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXD2Aag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbXD2Aaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:30:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46856 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbXD2A3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:29:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4633E6F8.3030402@s5r6.in-berlin.de>
Date: Sun, 29 Apr 2007 02:29:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: random thoughts on DEPRECATED and OBSOLETE
References: <Pine.LNX.4.64.0704280925270.24691@localhost.localdomain> <46337BD2.7000701@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281320560.27098@localhost.localdomain> <4633ACE4.50004@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281635190.28274@localhost.localdomain> <4633CA7F.6010505@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281919150.29483@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704281919150.29483@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> * deprecated:  while a feature is still supported, its use is
> discouraged because there is a better alternative that you should
> consider migrating to at your convenience.

IOW "discouraged, no {mid,long}-term commitment, alternative available,
supported"

> * obsolete:  while a feature is still in the tree, it is no longer
> supported and no one should need it anymore, and everyone *should* be
> using the better alternative at this point.

IOW "discouraged, no {mid,long}-term commitment, alternative available,
*un*supported"

Note, that's different from http://kerneltrap.org/node/7593 --- the
supported bit is new.  Why would I officially support what I deprecate?

Also, why don't we just adopt what "deprecated" and "obsolete" mean in
real life?  (English dictionaries say, one means "disapproved", the
other means "outdated" or "no longer in use".)  And if you don't find
these meanings applicable, other terms should be chosen whose
established meaning better matches what you want to express.

[...]
> there is an obvious timeline for features:
> 
>   normal -> deprecated -> obsolete

That wasn't clear (to me) from your earlier definitions.

IOW "normal" -> "obsolete and deprecated, phase 1" -> "obsolete and
deprecated, phase 2"  (using the real-life meanings of the terms here)

with the fine distinction that there is still support available in phase
1, however curious that is.

Besides, I find it unfeasible to divide a feature removal process into
two phases.  (I was involved in feature removals before and continue to
be involved in them.)

[...]
> in any event, i don't want to drag this out too much longer.

At least my pestering seems to lead to increasing precision in your
wordings.  And believe me, precision in a feature removal process is
valuable for each party involved.
-- 
Stefan Richter
-=====-=-=== -=-- ===-=
http://arcgraph.de/sr/
