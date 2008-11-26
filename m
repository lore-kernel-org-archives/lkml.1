Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYKZJaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYKZJaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbYKZJaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:30:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:39520 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbYKZJaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:30:05 -0500
Subject: Re: commit b1ee26b "radeonfb: accelerate imageblit and other
 improvements" freezes system on switching from X to text console
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081125231344.GA5190@soziologie.ch>
References: <20081125194457.GA4929@soziologie.ch>
	 <20081125231344.GA5190@soziologie.ch>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 20:29:57 +1100
Message-Id: <1227691797.7185.370.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 00:13 +0100, Gaudenz Steinlin wrote:
> On Tue, Nov 25, 2008 at 08:44:57PM +0100, Gaudenz Steinlin wrote:
> > Hi Ben
> > 
> > The changes in the commit mentioned in the subject freeze my system when
> > changing from X to a text console. The system freezes with a garbled
> > display. Reverting this commit fixes the problem.
> > 
> > The freeze only happens if DRI is enabled in X. It also does not happen
> > if I simply switch between different text consoles. 
> > 
> 
> OK, I searched a bit more and found
> http://bugzilla.kernel.org/show_bug.cgi?id=11875 which is possibly
> related. I also found the patch Ben proposed to fix this at
> http://lkml.org/lkml/2008/11/10/12. Unfortunately this patch did not fix
> my problem. 

The fix is for a different problem. I suspect the root cause is a bug in
X but I'm still trying to track it down.

I think I'll just do a patch that make the new acceleration conditional
on a kernel command line option for .28 final ...

Cheers,
Ben.
 

