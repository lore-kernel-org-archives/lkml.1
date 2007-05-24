Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbXEXWoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbXEXWoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXEXWoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:44:08 -0400
Received: from gw.goop.org ([64.81.55.164]:60108 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbXEXWoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:44:07 -0400
Message-ID: <4656152F.2060000@goop.org>
Date: Thu, 24 May 2007 23:43:59 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu> <20070524064235.GA2386@linux.vnet.ibm.com> <20070524080959.GA29151@elte.hu> <4655CA84.5060103@goop.org> <20070524205934.GA19672@elte.hu>
In-Reply-To: <20070524205934.GA19672@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> it treats it as a per-cpu clock.
>   

Excellent.  I'd noticed it seems to work pretty well in a Xen guest with
lots of stolen time, but I haven't really evaluated it in detail.

    J
