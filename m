Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYGREod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYGREod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 00:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbYGREoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 00:44:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:3513 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYGREoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 00:44:25 -0400
Date: Thu, 17 Jul 2008 22:44:20 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Anton Vorontsov <avorontsov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080718044420.GB9795@secretlab.ca>
References: <20080714164114.GA18784@polina.dev.rtsoft.ru> <dc452eaab83710e7d6f86dcc5d77bdda@kernel.crashing.org> <20080717110730.GA24775@polina.dev.rtsoft.ru> <20080717150715.GD31932@secretlab.ca> <20080718033512.GC18748@yookeroo.seuss>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718033512.GC18748@yookeroo.seuss>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 01:35:12PM +1000, David Gibson wrote:
> This brings us back to the issue we also have with DCR controlled
> devices.  Possibly we should have two ways of representing these
> connections: for "pure" GPIO-only or DCR-only devices, they appear
> under the relevant controller with the addresses encoded with 'reg'.
> For devices on other busses which also have a few GPIO lines / DCR
> registers, they would appear on the other bus with 'gpios' or
> 'dcr-reg' properties (or some new, generalized 'other-bus-reg'
> property).

On the other hand; it's just LEDs.  I think a single scheme is enough.

:-)

g.

