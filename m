Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZDGCxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZDGCxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZDGCxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:53:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60198 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZDGCxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:53:05 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Off topic: Numactl "distance" wrong
Cc: kosaki.motohiro@jp.fujitsu.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <87r609jtc2.fsf@basil.nowhere.org>
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org>
Message-Id: <20090407111539.F0F5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue,  7 Apr 2009 11:52:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's not enough. You would need to redo all the zone fallback tables
> in the VM that are initialized based on topology, do new scheduler
> topologies and all kind of other stuff.

I think this is very good viewpoint.

The rebuilding zone fallback table and scheduler topologies need to add
new lock.

Oh well, who need memory and scheduler performance regression?
Then, its /sys interface isn't so useful.


I don't think the manual setting of node distance improve
opteron's (or another small machine) performance.



