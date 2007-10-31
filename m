Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbXJaLgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbXJaLgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbXJaLgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:36:36 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:53458 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980AbXJaLgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:36:36 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Philipp Gruber <philipp.gruber@flupps.net>
Date: Wed, 31 Oct 2007 22:36:23 +1100
X-Spam-Score: 0.001
X-CSE-Spam-Checker-Version: SpamAssassin 3.1.3 (2006-06-01) on 
	note.orchestra.cse.unsw.EDU.AU
X-CSE-Spam-Level: 
X-CSE-Spam-Status: No, score=-2.6 required=4.0 tests=BAYES_00,UNPARSEABLE_RELAY 
	autolearn=ham version=3.1.3
Message-ID: <472868B7.6010702@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: Need information on elevator_dispatch_fn
References: <20071031100025.GC16598@mega2000.de>
In-Reply-To: <20071031100025.GC16598@mega2000.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Gruber wrote:
> So I need to 'reactivate' the whole dispatching process again. The only
> way to to this is probably a timer, but I couldn't get this working
> since I don't understand what calls dispatch_fn.

Hi Philipp,

Take a look how the AS and CFQ schedulers implement this.  In fact, the
CFQ scheduler implements policy similar to what you described.
as_work_handler() in block/as-iosched.c might be a good starting point.

-- Aaron

