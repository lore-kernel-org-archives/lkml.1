Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbZKSLSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbZKSLSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 06:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZKSLSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 06:18:36 -0500
Received: from www.tglx.de ([62.245.132.106]:42786 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbZKSLSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 06:18:36 -0500
Date: Thu, 19 Nov 2009 12:18:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesper Nilsson <jesper@jni.nu>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: Re: [patch 10/13] cris: Fixup last users of irq_chip->typename
In-Reply-To: <20091119111526.GB18155@jni.nu>
Message-ID: <alpine.LFD.2.00.0911191217520.24119@localhost.localdomain>
References: <20091117224852.846805939@linutronix.de> <20091117224916.725429771@linutronix.de> <20091119111526.GB18155@jni.nu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Jesper Nilsson wrote:

> On Tue, Nov 17, 2009 at 10:51:20PM -0000, Thomas Gleixner wrote:
> > The typename member of struct irq_chip was kept for migration purposes
> > and is obsolete since more than 2 years. Fix up the leftovers.
> 
> Looks good, should I take this through the CRIS-tree? Otherwise, here's my

Please push it through your tree.

Thanks,

	tglx
