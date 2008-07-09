Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYGIPWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYGIPWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYGIPVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:21:50 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:10428 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917AbYGIPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:21:49 -0400
X-IronPort-AV: E=Sophos;i="4.30,331,1212364800"; 
   d="scan'208";a="950794"
Message-ID: <4874D79B.7000101@eu.citrix.com>
Date: Wed, 09 Jul 2008 16:22:03 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0 of 2] fbcon: blinking text fix and implementation
References: <486A4F5F.7030506@eu.citrix.com> <20080709144704.GA11006@ucw.cz>
In-Reply-To: <20080709144704.GA11006@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jul 2008 15:21:45.0738 (UTC) FILETIME=[7FBD26A0:01C8E1D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> I'd prefer to call that 'feature' and leave it alone. Burning cpu
> power to provide annoying blinking text is at least questionable...
> 


I knew someone would have replied something like this, sooner or later;
this is why I sent two patches instead of just one.
The first one is a bugfix, the second one is the implementation of a
feature that some are not really missing.

Anyway, I am not burning so much cpu power: I have implemented a very
simple flag mechanism to scan the screen only when blinking text is
added to the screen or if we are scrolling.
The screen buffer is not so big, but if you are so concerned about
performances, I can implement a more efficient way to know whether we
need to scan the screen or not...
