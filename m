Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZG2OoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZG2OoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZG2OoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:44:17 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:60090 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZG2OoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:44:16 -0400
Date: Wed, 29 Jul 2009 16:44:11 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: dwalker@fifo99.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
Message-ID: <20090729164411.6d7bd9f6@skybase>
In-Reply-To: <200907291415.n6TEFJkA019086@d06av05.portsmouth.uk.ibm.com>
References: <200907291415.n6TEFJkA019086@d06av05.portsmouth.uk.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 08:15:19 -0600
dwalker@fifo99.com wrote:

> > Remove clocksource_read, clocksource_enable and clocksource_disable
> > inline functions. No functional change.
> > 
> 
> Your still not really explaining this one, is this suppose to be
> cleaner? Or is this related to some other part of your clean up?

The only one of the three inline functions that is a bit more
complicated is clocksource_enable() because of the mult_orig logic. But
that goes away with a later patch. The function aren't accessors either,
they are used exclusively by the timekeeping code. In short, they are
useless, don't you think?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

