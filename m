Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbYDALlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbYDALlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYDALk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:40:56 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:5334 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbYDALkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:40:55 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Customize sched domain via cpuset
References: <47F21BE3.5030705@jp.fujitsu.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Apr 2008 13:40:50 +0200
In-Reply-To: <47F21BE3.5030705@jp.fujitsu.com>
Message-ID: <87zlsdzttp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Apr 2008 11:34:13.0397 (UTC) FILETIME=[4F69FC50:01C893EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:

> Using cpuset, now we can partition the system into multiple sched domains.
> Then, how about providing different characteristics for each domains?

Did you actually see much improvement in any relevant workload
from tweaking these parameters?  If yes what did you change?
And how much did it gain?

Ideally the kernel should perform well without much tweaking
out of the box, simply because most users won't tweak. Adding a 
lot of such parameters would imply giving up on good defaults which 
is not a good thing.

-Andi
