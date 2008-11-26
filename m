Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbYKZJ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbYKZJ3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYKZJ3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:29:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:39506 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbYKZJ3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:29:06 -0500
Subject: Re: commit b1ee26b "radeonfb: accelerate imageblit and other
 improvements" freezes system on switching from X to text console
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gaudenz Steinlin <gaudenz@debian.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081125194457.GA4929@soziologie.ch>
References: <20081125194457.GA4929@soziologie.ch>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 20:28:59 +1100
Message-Id: <1227691739.7185.369.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 20:44 +0100, Gaudenz Steinlin wrote:
> Hi Ben
> 
> The changes in the commit mentioned in the subject freeze my system when
> changing from X to a text console. The system freezes with a garbled
> display. Reverting this commit fixes the problem.
> 
> The freeze only happens if DRI is enabled in X. It also does not happen
> if I simply switch between different text consoles. 
> 
> My system is a PowerPC PowerBook G4 15" (PowerBook5,8) with a ATI
> Mobility Radeon 9600 M10 graphics card. I'm running X.org 1.5.1 with the
> radeon driver version 6.9.0+git20080826.a3cc1d7a from Debian
> experimental.
> 
> Sorry, I don't have the knowledge nor the time to fix this myself, but I
> would be happy to test an improved patch. Please also feel free to ask
> if you need more information.

It's annoying as I have approximately the same machine and couldn't
reproduce the problem lately (slightly different X version though, from
Ubuntu intrepid).

I'll give it another go.

Cheers,
Ben.


