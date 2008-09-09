Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYIIXWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYIIXWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYIIXWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:22:22 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:41493 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYIIXWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:22:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48C70526.1030701@citrix.com>
Date: Wed, 10 Sep 2008 00:22:14 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] xen: fix pinning when not using split pte locks
References: <> <1220959508-13806-1-git-send-email-alex.nixon@citrix.com> <48C6BB00.9040607@goop.org> <48C6CCD7.8030800@citrix.com> <48C6DE6E.1070804@goop.org> <48C6F80E.8010509@citrix.com> <48C6FC0D.9040009@goop.org>
In-Reply-To: <48C6FC0D.9040009@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> We only pin PTE pages when using split PTE locks, so don't do the
> pin/unpin when attaching/detaching pte pages to a pinned pagetable.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>   
Cheers Jeremy - a better solution.  Worth mentioning - this doesn't 
exist peacefully alongside my patch 965fe78fe

Ingo - could you revert that please?

Thanks,
- Alex
