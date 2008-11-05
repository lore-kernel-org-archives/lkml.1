Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYKECSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYKECSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 21:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYKECSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 21:18:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:36473 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbYKECSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 21:18:36 -0500
Message-ID: <4911023B.20901@kernel.org>
Date: Wed, 05 Nov 2008 11:17:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mark Lord <liml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <20081104062734.GA4420@havoc.gtf.org> <200811041753.53342.rjw@sisk.pl> <49107F76.60107@rtr.ca> <200811041807.17183.rjw@sisk.pl>
In-Reply-To: <200811041807.17183.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Nov 2008 02:17:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>> So, what happens if we just don't ever spin them down from the kernel?
>> Presumably they still spin-down normally (HP or otherwise) when the BIOS
>> actually cuts the power at the end of all of this?
>>
>> Just curious..
> 
> Well, I'll let Tejun answer that. :-)

The BIOSen on the affected HP ones will spin the drives down during
power off or hibernation, so there won't be any problem (that's what the
patch does, BTW).  For all other machines, the drive will do emergency
head unload which usually sounds a bit differently and shortens the
lifespan of the drive.

Thanks.

-- 
tejun
