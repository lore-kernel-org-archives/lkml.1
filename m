Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYARJAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYARJAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYARI7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:59:54 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38706 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbYARI7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:59:53 -0500
Date: Fri, 18 Jan 2008 01:03:37 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] X86: fix typo PAT to X86_PAT
In-reply-to: <20080118081040.GB16597@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: venkatesh.pallipadi@intel.com, LKML <linux-kernel@vger.kernel.org>
Message-id: <200801180103.37771.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801171950.32458.yinghai.lu@sun.com>
 <20080118081040.GB16597@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 12:10:40 am Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> >  config MTRR
> >  	bool "MTRR (Memory Type Range Register) support"
> > -	depends on !PAT
> > +	depends on !X86_PAT
> >  	---help---
> >  	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
> >  	  the Memory Type Range Registers (MTRRs) may be used to control
> 
> thanks. But, i think we should rather do the following: if X86_PAT is 
> eanbled then /proc/mtrr should be read-only. There's no problem 
> _looking_ at MTRR contents, as long as we do not try to modify them. Hm?

anyway 

depends on !PAT

need to be removed.

it seems when PAT is used, some code still touch MTRR.

YH
