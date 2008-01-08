Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYAHRFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYAHRFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbYAHRFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:05:08 -0500
Received: from main.gmane.org ([80.91.229.2]:52310 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbYAHRFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:05:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Date: Tue, 8 Jan 2008 17:01:30 +0000 (UTC)
Message-ID: <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <p73odbwqmx2.fsf@bingen.suse.de>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-08, Andi Kleen <andi@firstfloor.org> wrote:
> tune2fs -i0 -c0 device      for each file system
>
> Yes that should be default, unfortunately it is not. It's one 
> of the first things I do on new machines.

I have ages ago increased those counts, but I don't want to
completely disable them. The problem is that the superblock
is corrupted to indicate absurd "31352 days since last check".
Who knows, maybe it would even corrupt those settings.

-- 
Tuomo

