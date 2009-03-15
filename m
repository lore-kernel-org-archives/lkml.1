Return-Path: <linux-kernel-owner+w=401wt.eu-S1750903AbZCOC6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903AbZCOC6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 22:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbZCOC6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 22:58:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:24514 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbZCOC6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 22:58:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dpi7cFjiMkyC+2GB96wDeBP1a0gHb0rYyOGuqYQJ17fkRPQ8Qe/69cQy8VDDGfdBHg
         AumhJCR82fgFqM4ae5SiZcubC+Hs/Y5DDQUTa4rbdRdc66m4S3WepouxRUQV2ORHs0QS
         T4rCyRbzN1hBKz4J7+0ZqtgsVlnZ6jqyFMglw=
MIME-Version: 1.0
In-Reply-To: <MiincthRUSI.A.eKC.F4BvJB@chimera>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
Date: Sun, 15 Mar 2009 10:58:16 +0800
Message-ID: <b6a2187b0903141958u9dae0fdk1f44b387108b99e4@mail.gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 3:01 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12414
> Subject         : iwl4965 cannot use "ap auto" on latest 2.6.28/29?
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-01-05 4:13 (69 days old)
> References      : http://marc.info/?l=linux-kernel&m=123112882127823&w=4

Still not working in linux-2.6.29-rc8. Broken after the commit below.
There were many changes to wireless after this commit, and simply
reverting this commit will break compiling.

Jeff.



commit 41bb73eeac5ff5fb217257ba33b654747b3abf11
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Oct 29 01:09:37 2008 +0100

    mac80211: remove SSID driver code
