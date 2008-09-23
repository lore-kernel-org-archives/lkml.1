Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYIWHWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYIWHWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 03:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYIWHV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 03:21:58 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:54227 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752917AbYIWHV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 03:21:58 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] file capabilities: add no_file_caps switch (v2)
References: <beYE7-1Xc-41@gated-at.bofh.it> <beZ72-2GM-5@gated-at.bofh.it>
	<bf035-3Tp-5@gated-at.bofh.it>
From: Markku Savela <msa@moth.iki.fi>
Date: Tue, 23 Sep 2008 10:21:54 +0300
In-Reply-To: <bf035-3Tp-5@gated-at.bofh.it> (Andreas Gruenbacher's message of "Mon\, 22 Sep 2008 22\:20\:08 +0200")
Message-ID: <87tzc7fht9.fsf@burp.tkv.asdf.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andreas Gruenbacher <agruen@suse.de> writes:

> Sure, that would work as well, except that I think that file
> capabilities should always default to "on" as they will become a
> standard security mechanism before long. We just don't have much
> system management tool support yet, and I would like to give that
> some more time safely, without putting users at unnecessary risk.

As I've said elsewhere, I consider above a bad move. The "file
capabilities" are just setgid/setuid executables in disguise (although
with little finer control).

I would prefer two choices for capabilities:

 1) file capabilities, for those who think they work

 2) no file capabilities, but just normal inheritance. There should be
 nothing mystical about this. The credential (uid, groups) inherit
 just fine without problems. Why not capabilities?


