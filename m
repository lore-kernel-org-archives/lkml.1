Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbXLONCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbXLONCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 08:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbXLONCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 08:02:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52367 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbXLONCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 08:02:31 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 15 Dec 2007 14:01:56 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 06/18] ieee1394: nopage
To: npiggin@suse.de
cc: akpm@linux-foundation.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071205071627.360419000@nick.local0.net>
Message-ID: <tkrat.f2581cb1f798084e@s5r6.in-berlin.de>
References: <20071205071547.701344000@nick.local0.net>
 <20071205071627.360419000@nick.local0.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  5 Dec, npiggin@suse.de wrote:
> Convert ieee1394 from nopage to fault.
> Remove redundant vma range checks (correct resource range check is retained).

I finally did a brief runtime test.  Works for me with coriander,
dvgrab, and kino on x86-64.  Committed to linux1394-2.6.git.
-- 
Stefan Richter
-=====-=-=== ==-- -====
http://arcgraph.de/sr/

