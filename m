Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbZDGGR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbZDGGR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZDGGRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:17:37 -0400
Received: from iona.labri.fr ([147.210.8.143]:33979 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbZDGGRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:17:35 -0400
Message-ID: <49DAF003.1070605@inria.fr>
Date: Tue, 07 Apr 2009 08:17:39 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org> <20090407111539.F0F5.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090407111539.F0F5.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> That's not enough. You would need to redo all the zone fallback tables
>> in the VM that are initialized based on topology, do new scheduler
>> topologies and all kind of other stuff.
> 
> I think this is very good viewpoint.
> 
> The rebuilding zone fallback table and scheduler topologies need to add
> new lock.

Could you clarify how changing numa distances could break
zone fallback tables and scheduler topologies?

> Oh well, who need memory and scheduler performance regression?
> Then, its /sys interface isn't so useful.

If changing the slit table at runtime is too hard, what about
changing it at boot through a new kernel command-line parameter?

> I don't think the manual setting of node distance improve
> opteron's (or another small machine) performance.

Well, some user-space application may use these distances
to improve their binding. Maybe nobody does yet because
numa distances have never been available on x86_64 boxes...

Brice
