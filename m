Return-Path: <linux-kernel-owner+w=401wt.eu-S1763091AbZEGUep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763091AbZEGUep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763008AbZEGUea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:34:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38594 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762824AbZEGUe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:34:29 -0400
Date: Thu, 7 May 2009 21:34:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Snook <chris.snook@gmail.com>
Cc: akataria@vmware.com, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507213403.3a75a6fb@lxorguk.ukuu.org.uk>
In-Reply-To: <13a12eea0905071329s79fb262tf89ed901a77726ae@mail.gmail.com>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
	<1241560625.8665.17.camel@alok-dev1>
	<13a12eea0905070935o5abbeb49n8320d06c15b19b56@mail.gmail.com>
	<1241715373.32495.21.camel@alok-dev1>
	<13a12eea0905071329s79fb262tf89ed901a77726ae@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Given your use case, what you really need to do is get Red Hat,
> >> Novell, et al. on the phone and ask them to ship kernels with HZ=100,
> >> because the distributions do their own thing anyway.

As a side note Red Hat ships runtime configurable tick behaviour in RHEL
these days. HZ is fixed but the ticks can be bunched up. That was done as
a quick fix to keep stuff portable but its a lot more sensible than
randomly messing with the HZ value and its not much code either.

