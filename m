Return-Path: <linux-kernel-owner+w=401wt.eu-S1761411AbYDYPKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbYDYPKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYDYPJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:09:51 -0400
Received: from hs-out-0708.google.com ([64.233.178.249]:30548 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYDYPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=AVORiMLSbDC/SFfymtdplclnTNiX7zZY+/UR6Eeiz9lXBIHOrohnL7ph2WY9MTjlGlA0Y9TwqAZxlAnN4C4xXDs76oOus/jsd5iZNc+Kj6AzUuJFSeVfH6LguBvWFXE6/xmGebsFMk2QegOphbYTDGoBQ/Bu0H18oyF5KCpNWoI=
Date: Fri, 25 Apr 2008 11:09:30 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rodney Lorrimar <rodney@rodney.id.au>
Cc: Pavel Machek <pavel@suse.cz>, jikos@suse.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew McNabb <amcnabb@mcnabbs.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Input: adbhid - restore_capslock_events fixes
Message-ID: <20080425110753.ZZRA012@mailhub.coreip.homeip.net>
References: <20080423101416.GA4735@solaria.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423101416.GA4735@solaria.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodney,

On Wed, Apr 23, 2008 at 12:14:16PM +0200, Rodney Lorrimar wrote:
> Hi Dmitry,
> 
> Would you consider these for review and inclusion in the input tree?
> 
> They fix 2 out of 3 problems I know of in the simulation of capslock
> up/down key events on Apple laptop keyboards.

They look reasonable, I will apply them, thank you.

> The third problem - that
> sometimes the capslock key gets stuck down - I haven't looked at
> properly yet, but I know that the "capslock key up" packet is never
> received by adbhid_keyboard_input so the problem is in adb.c or
> via-pmu.c, or possibly the hardware never sends the event at all.
> 
> Pavel Machek suggested removing the parameter, and I would do this
> after fixing the third problem. This would probably happen after the
> once-or-twice-a-day event of stuck capslock annoys me enough to have a
> deeper look.
> 

OK.

-- 
Dmitry
