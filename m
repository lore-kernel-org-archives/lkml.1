Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZDGHDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZDGHDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZDGHDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:03:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZDGHDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:03:24 -0400
Date: Tue, 7 Apr 2009 09:05:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
Message-ID: <20090407070530.GJ17934@one.firstfloor.org>
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org> <20090407111539.F0F5.A69D9226@jp.fujitsu.com> <49DAF003.1070605@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DAF003.1070605@inria.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, some user-space application may use these distances
> to improve their binding.

I'm not aware of any that does. In general applications usually
only use the bare basics of NUMA API (if at all), the fancy stuff tends
to be more slideware.

If it's true then the correct place would be to fix the BIOS.

> Maybe nobody does yet because
> numa distances have never been available on x86_64 boxes...

That's an incorrect statement. There are x86-64 boxes which
report correct NUMA distances.

-Andi

