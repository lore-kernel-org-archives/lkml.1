Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab0BGW6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 17:58:07 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:46559 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab0BGW6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:58:05 -0500
From: Oliver Neukum <oliver@neukum.org>
To: David Rientjes <rientjes@google.com>
Subject: Re: Improving OOM killer
Date: Fri, 5 Feb 2010 08:35:30 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Lubos Lunak <l.lunak@suse.cz>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
References: <201002012302.37380.l.lunak@suse.cz> <alpine.LNX.2.00.1002041044080.15395@pobox.suse.cz> <alpine.DEB.2.00.1002041335140.6071@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002041335140.6071@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002050835.30550.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Februar 2010 22:39:08 schrieb David Rientjes:
> > If we really want kernel to detect forkbombs (*), we'd have to establish 
> > completely separate infrastructure for that (with its own knobs for tuning 
> > and possibilities of disabling it completely).
> > 
> 
> That's what we're trying to do, we can look at the shear number of 
> children that the parent has forked and check for it to be over a certain 
> "forkbombing threshold" (which, yes, can be tuned from userspace), the 
> uptime of those children, their resident set size, etc., to attempt to 
> find a sane heuristic that penalizes them.

Wouldn't it be saner to have a selection by user, so that users that
are over the overcommit limit are targeted?

	Regards
		Oliver
