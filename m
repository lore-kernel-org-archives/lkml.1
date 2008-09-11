Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYIKDan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYIKDan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 23:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYIKDad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 23:30:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:33103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYIKDad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 23:30:33 -0400
Date: Wed, 10 Sep 2008 20:28:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org
Subject: 3 further range-hrtimer patches
Message-ID: <20080910202803.42b5f251@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as reply to this email I have 3 further patches for the range-hrtimer
patchkit:

Patch 1 and 2 change the futex and nanosleep code to also use
range-hrtimers with the per process slack

Patch 3 adds a "peek-a-timer" capability; this is used from the cpuidle
loop to run any soft-expired timers just before looking at how long
we'll be idle (for determining the C-state etc); that way we'll have a
longer idle period.

I'll add these patches to the git tree in a day or two, adjusted for
comments based on this posting


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
