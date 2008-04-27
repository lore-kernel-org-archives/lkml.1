Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbYD0XAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbYD0XAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYD0XAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:00:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37812
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbYD0XAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:00:41 -0400
Date: Sun, 27 Apr 2008 16:00:41 -0700 (PDT)
Message-Id: <20080427.160041.223283677.davem@davemloft.net>
To: arjan@infradead.org
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Breakage caused by unreviewed patch in x86 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080427155803.73f0efcf@laptopd505.fenrus.org>
References: <1209329485.3801.46.camel@localhost.localdomain>
	<20080427155803.73f0efcf@laptopd505.fenrus.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Sun, 27 Apr 2008 15:58:03 -0700

> On Sun, 27 Apr 2008 16:51:25 -0400
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > This patch:
> > 
> > commit 6371b495991debfd1417b17c2bc4f7d7bae05739
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Wed Jan 30 13:33:40 2008 +0100
> > 
> >     x86: change ioremap() to default to uncached
> > 
> > As far as I can tell went blindly into the x86 tree without being
> > shared on any mailing list at all.  How can something that completely
> > alters the semantics of ioremap on x86 platforms go in without any
> > review.
> 
> it changed from "whatever coinflip you got" to "predictable outcome". 

You're making technical responses to a question about process.

The core issue how the change in question was handled.

