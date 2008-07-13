Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYGMT32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYGMT32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbYGMT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:29:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:36777 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbYGMT3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wSWQyj998cOVpLzPtOnQQPzwsyKKN5zStoQXchJQLmXMNfPABzA90ME8j1huCtqRwk
         WgzVETocftkwYpIa/SlzzFAPljLI77zgyuMlCFqXakfJvd34UJV2h5J990k8Am/HEMnr
         ZWMRBc31A9W8QrBHEKPLt5FCuEk92OcYEaqpU=
Message-ID: <19f34abd0807131229u45808531pdcbb9cd8b439c436@mail.gmail.com>
Date: Sun, 13 Jul 2008 21:29:14 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10955] v2.6.26-rc7: BUG task_struct: Poison overwritten
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <c6ZRbn0adb.A.zd.EIleIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.zd.EIleIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 13, 2008 at 8:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10955
> Subject         : v2.6.26-rc7: BUG task_struct: Poison overwritten
> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> Date            : 2008-06-21 19:24 (23 days old)
> References      : http://marc.info/?l=linux-kernel&m=121407641925121&w=4
> Handled-By      : Peter Zijlstra <a.p.zijlstra@chello.nl>

We've seen a rather lot of fixes for cpu hotplug and the scheduler
over the last few weeks. I'm suspecting that this one might also have
been fixed unknowingly by one of the other commits (this is backed by
the fact that I haven't been able to reproduce _any_
cpu-hotplug-related failure as of the latest mainline kernel), on the
other hand I don't know exactly why.

I guess I should run a longer test to see if this comes up again.

(Oh, maybe it was an RCU-type thing? Nick Piggin recently had a patch
that fixed some RCU error. Peter?)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
