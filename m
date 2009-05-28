Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbZE1OQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbZE1OQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbZE1OQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:16:20 -0400
Received: from tango.0pointer.de ([85.214.72.216]:34800 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbZE1OQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:16:19 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2009 10:16:19 EDT
Date: Thu, 28 May 2009 16:15:55 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org
Subject: Re: [PATCH 3/3] scheduler: introduce SCHED_RESET_ON_FORK
	scheduling policy flag
Message-ID: <20090528141555.GA17373@tango.0pointer.de>
References: <20090528140953.GA16470@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528140953.GA16470@omega>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28.05.09 16:09, Lennart Poettering (mzxreary@0pointer.de) wrote:

Please ignore the 3/3 in the subject of the original patch. It's just
this one patch. Sorry for the confusion.

> This patch introduces a new flag SCHED_RESET_ON_FORK which can be passed
> to the kernel via sched_setscheduler(), ORed in the policy parameter. If
> set this will make sure that when the process forks a) the scheduling
> priority is reset to DEFAULT_PRIO if it was higher and b) the scheduling
> policy is reset to SCHED_NORMAL if it was either SCHED_FIFO or SCHED_RR.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
