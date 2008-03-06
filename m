Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYCFHz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYCFHz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 02:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYCFHzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 02:55:10 -0500
Received: from www.tglx.de ([62.245.132.106]:54938 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYCFHzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 02:55:09 -0500
Date: Thu, 6 Mar 2008 08:54:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/5] object debugging infrastructure V2
In-Reply-To: <20080306014810.GA4927@kroah.com>
Message-ID: <alpine.LFD.1.00.0803060828180.3099@apollo.tec.linutronix.de>
References: <20080305154829.185609547@linutronix.de> <20080306014810.GA4927@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Greg KH wrote:
> Here's a patch adding kobjects to this infrastructure (I didn't use a
> new CONFIG option, which it probably should be.)
> 
> Does this look correct?  I can't tell if this is going to catch
> anything, as my trees all seem to have these kinds of bugs worked out
> now, as we are already catching a number of these types of things
> already with kobjects.
> 
> Should I be doing more checks?  Different things based on the state of
> the object?

Depends on the kind of state of objects you have. Right now you only
track the initialized and the destroyed state. The question is whether
there is some other state like "access". I have a look.

Thanks,

	tglx 
