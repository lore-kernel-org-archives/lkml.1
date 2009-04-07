Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZDGH53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZDGH53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZDGH46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:56:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35057 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZDGH46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:56:58 -0400
Date: Tue, 7 Apr 2009 09:59:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Brice Goglin <Brice.Goglin@inria.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
Message-ID: <20090407075908.GL17934@one.firstfloor.org>
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org> <20090407111539.F0F5.A69D9226@jp.fujitsu.com> <49DAF003.1070605@inria.fr> <20090407070530.GJ17934@one.firstfloor.org> <alpine.DEB.2.00.0904070035570.20262@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904070035570.20262@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 12:44:21AM -0700, David Rientjes wrote:
> On Tue, 7 Apr 2009, Andi Kleen wrote:
> 
> > I'm not aware of any that does. In general applications usually
> > only use the bare basics of NUMA API (if at all), the fancy stuff tends
> > to be more slideware.
> > 
> > If it's true then the correct place would be to fix the BIOS.
> > 
> 
> We already verify that each node has local distance to itself and that its 
> distance to any other node is greater than local when determining whether 
> the SLIT is valid.
> 
> It would also be possible to verify that the distance between two 
> localities is described consistently in the table (like in the following 
> patch).

Do you have an real-world example where this is wrong? 

> 
> I do think it would be helpful to add an acpi=noslit option, however, that 
> would disable parsing the SLIT if it is known to incorrectly describe the 
> physical topology of the system.

The check heuristic handles this. I am not aware of a case where it really
fails and let's something really bogus through.

In general this thread seems to contain much more speculation than
facts.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
