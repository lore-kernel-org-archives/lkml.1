Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbZFIWyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbZFIWyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZFIWyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:54:04 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:42902 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZFIWyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:54:03 -0400
Subject: Re: [RFC PATCH 1/1] smi_detector: A System Management Interrupt
 detector
From: Jon Masters <jonathan@jonmasters.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
In-Reply-To: <20090609145607.d8944778.akpm@linux-foundation.org>
References: <20090531163117.502167374@jonmasters.org>
	 <20090531163343.771922592@jonmasters.org>
	 <20090601205720.825d3048.akpm@linux-foundation.org>
	 <1244584201.30733.93.camel@localhost.localdomain>
	 <20090609145607.d8944778.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 09 Jun 2009 18:53:27 -0400
Message-Id: <1244588008.30733.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-09 at 14:56 -0700, Andrew Morton wrote:
> On Tue, 09 Jun 2009 17:50:01 -0400
> Jon Masters <jonathan@jonmasters.org> wrote:
> 
> > > > +	if (0 != err)
> > > 
> > > 	if (err != 0)
> > > 
> > > or
> > > 
> > > 	if (err)
> > > 
> > > would be more typical.
> > 
> > The former runs the risk of assignment,
> 
> yup, which is why gcc will warn if you do
> 
> 	if (err = 0)
> 
> If you really meant to do that, then gcc can be silenced by
> double-parenthesising.  We consider this "good enough" for kernel
> purposes, so we generally don't use the `if (CONSTANT == variable)' trick.

Ah, yes, good point.

Jon.


