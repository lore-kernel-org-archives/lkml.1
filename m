Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYBIIiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYBIIiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 03:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYBIIio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 03:38:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41746 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYBIIin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 03:38:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47AD6631.8070800@s5r6.in-berlin.de>
Date: Sat, 09 Feb 2008 09:37:05 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Jonathan Corbet <corbet@lwn.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Documenting patch tags yet one more time
References: <20080208130126.e05be25d.pj@sgi.com>	<27099.1202503342@vena.lwn.net> <20080208182317.525c4d1f.pj@sgi.com>
In-Reply-To: <20080208182317.525c4d1f.pj@sgi.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson would like to:
> explain more clearly that PATCH's
> should start off, right from the top or after the initial From: line if
> present, with:
> 
>   - The body of the explanation, which will be copied to the
>     permanent changelog to describe this patch.
> 
> rather than opening with ephemeral reactions to the discussion of the
> moment which will make little "sense to a competent reader who has long
> since forgotten the immediate details of the discussion that might have
> led to this patch."
> 
> As best my legalistic mind understands the patch format, such ephemeral
> reactions should go after the "---" marker line, in the same section as
> the diffstat would be placed.
> 
> Or perhaps the patch format should be changed in this regard, since it
> is cumbersome and unnatural to embed the ephemeral opening comments
> half way down the patch, rather than opening with them.

In common practice, the changelog does not start before the _last_ From:
line (rather than the initial From: line).

	ephemera
	From: author
	changelog
	tags
	changelog, continued
	tags
	---
	ephemera, diffstat
	diff
	ephemera

There may be a Date: somewhere before the changelog as well.  The first
line of the changelog is the one to appear in shortlogs.  It may be
preceded by Subject:.
-- 
Stefan Richter
-=====-==--- --=- -=--=
http://arcgraph.de/sr/
