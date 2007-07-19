Return-Path: <linux-kernel-owner+w=401wt.eu-S937699AbXGSO1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937699AbXGSO1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761491AbXGSO0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:26:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53099 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbXGSO0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:26:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <469F749F.8030606@s5r6.in-berlin.de>
Date: Thu, 19 Jul 2007 16:26:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: does CONFIG_UNUSED_SYMBOLS have any value anymore?
References: <Pine.LNX.4.64.0707190849450.30763@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707190849450.30763@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
...
> it's not clear if that means that it was a *one-time* transition
> aid which is now unnecessary, or whether it's an *ongoing* aid which
> might be used at any time.  currently, there are no invocations of
> EXPORT_UNUSED_SYMBOL[_GPL] anywhere in the tree.  so does that mean
> this feature can be tossed?  or might it still be used every so often?

git-blame (or qgit, which I actually used) points from this part of
lib/Kconfig.debug to the following chunk in
Documentation/feature-removal-schedule.txt:

What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
	(temporary transition config option provided until then)
	The transition config option will also be removed at the same time.
When:	before 2.6.19
Why:	Unused symbols are both increasing the size of the kernel binary
	and are often a sign of "wrong API"
Who:	Arjan van de Ven <arjan@linux.intel.com>
-- 
Stefan Richter
-=====-=-=== -=== =--==
http://arcgraph.de/sr/
