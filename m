Return-Path: <linux-kernel-owner+w=401wt.eu-S1762414AbYEXVGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762414AbYEXVGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758220AbYEXVGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:06:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:24424 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060AbYEXVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:06:24 -0400
Subject: Re: your mail
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805242149170.3295@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0805242149170.3295@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Sat, 24 May 2008 14:06:21 -0700
Message-Id: <1211663181.18130.203.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-05-24 at 22:05 +0200, Thomas Gleixner wrote:

> > If that's the requirement then code that cleans up the corner case that
> > I've identified, which is also minimal should be acceptable .. Since
> > it's meeting the same requirement you layed out above for the original
> > plist changes.
> 
> Your code solves the least to worry about corner case and hurts
> performance for nothing. You take extra locks in the hot path for no
> benefit.
> 
> Aside of that it introduces lock order problems and we can really do
> without extra useless complexity in the futex code.
> 
> You can argue in circles. This is not going anywhere near mainline.

Above I'm not speaking about my code, I'm only speaking in terms of a
solution to this case, even if it isn't mine..

Daniel



