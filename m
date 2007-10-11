Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXJKWMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXJKWMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbXJKWMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:12:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41313 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbXJKWMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:12:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470E9F92.1030604@s5r6.in-berlin.de>
Date: Fri, 12 Oct 2007 00:11:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation/patch-tags v3
References: <30616.1192133818@lwn.net>	 <1192135811.7899.25.camel@heimdal.trondhjem.org>	 <470E93D3.5050707@s5r6.in-berlin.de> <1192139467.7899.55.camel@heimdal.trondhjem.org>
In-Reply-To: <1192139467.7899.55.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Thu, 2007-10-11 at 23:21 +0200, Stefan Richter wrote:
>> people in the patch
>> forwarding chain should only add this tag if the reviewer sent it
>> explicitly in his response.  Unlike with Acked-by and Tested-by, we must
>> not guess whether a reviewer wants to have his Reviewed-by added.
> 
> In that case the reviewer should be made part of the forwarding chain,
> and it should be made clear to whoever is upstream that this is a patch
> that has not been modified since it was reviewed.

It's more comfortable for the reviewer to send a mail reply with the tag.

But modifications after review are a problem either way.  (If the
modifications are minor, add a description below the Reviewed-by and
sign off below that additional description.  If they are major, drop the
Reviewed-by.  However, a follow-up patch instead of modifying the
reviewed patch should be considered and may be suitable in many cases,
since a patch which passed review should already be fine for commit on
its own.)

>> > Being sure of something and making guarantees are different things.
> 
> To a lawyer, yes. To everyone else, no, and the GPL already tells you
> that you are given no warranties.

OK.
-- 
Stefan Richter
-=====-=-=== =-=- -=-==
http://arcgraph.de/sr/
