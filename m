Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbYDUTts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbYDUTts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbYDUTti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:49:38 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:20852 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYDUTti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:49:38 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: Re: ISDN testing
From: Andi Kleen <andi@firstfloor.org>
References: <20080420223959.GA17998@havoc.gtf.org>
	<200804210205.38891.elendil@planet.nl> <480BF15D.2090100@garzik.org>
	<200804211536.57655.elendil@planet.nl> <480CE960.4050000@garzik.org>
Date: Mon, 21 Apr 2008 21:48:24 +0200
In-Reply-To: <480CE960.4050000@garzik.org> (Jeff Garzik's message of "Mon, 21 Apr 2008 15:22:08 -0400")
Message-ID: <878wz76lbr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2008 19:41:35.0387 (UTC) FILETIME=[B5428EB0:01C8A3E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:
>
> Yeah, that's what my patchset does -- splits the "hisax" driver into
> multiple smaller drivers.  Thus, "modprobe hisax" produces the results
> that you are seeing.

That will break a lot of user's setup.

> You'll need to determine which newly-created kernel module applies to
> your hardware.  Let me know if you need help with that.  The new
> drivers should be in
> /lib/modules/2.6.25-isdn/kernel/drivers/isdn/hisax/ provided that you
> enabled them in the kernel configuration.

One way to avoid that issue would be to continue having a dummy
"hisax" module that just depends on all the other drivers with 
a symbol reference.
 
That could be optional with some compat CONFIG.

-Andi
