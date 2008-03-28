Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYC1TsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYC1TsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYC1Tr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:47:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41556 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYC1Tr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:47:56 -0400
Message-ID: <47ED4B4D.8030200@oracle.com>
Date: Fri, 28 Mar 2008 12:47:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [Pull] Some documentation patches
References: <13387.1206728412@vena.lwn.net>
In-Reply-To: <13387.1206728412@vena.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> I've noticed that getting documentation patches merged seems to be a
> slower and more uncertain process than it was a while back.  So I
> figured I'd try to be one of the cool folks with their own git tree and
> see if that works better.  Linus, if you agree, could you please pull:

A lot of the time it's just a matter of the "merge window" for
non-critical patches.  OTOH, doc patches could be merged at just about
any time IMO.

>   git://git.lwn.net/linux-2.6.git docs
> 
> To get the following:
> 
> Jonathan Corbet (3):
>       Add the seq_file documentation
>       Fill out information on patch tags in SubmittingPatches
>       Add a comment discouraging use of in_atomic()
> 
>  Documentation/SubmittingPatches        |   54 ++++++-
>  Documentation/filesystems/00-INDEX     |    2 +
>  Documentation/filesystems/seq_file.txt |  283 ++++++++++++++++++++++++++++++++
>  include/linux/hardirq.h                |    8 +
>  4 files changed, 344 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/filesystems/seq_file.txt
> 
> These changes are (1) an updated version of the seq_file document first
> posted in 2003, (2) the much-reviewed patch tags documentation, and
> (3) a comment warning developers that in_atomic() doesn't mean what they
> think it means.  No code changes.
> 
> If this works out, and nobody objects, I'll try to run this tree into
> the future as a collection point for documentation patches which don't
> have a more obvious tree to travel through.

Getting doc patches merged can be slow sometimes (slower than needed),
but I'm still having success at it.

-- 
~Randy
