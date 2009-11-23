Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZKWOuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZKWOuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZKWOuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:50:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:37132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbZKWOuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:50:14 -0500
Date: Mon, 23 Nov 2009 06:52:01 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size
 config options
Message-ID: <20091123065201.564d4b16@infradead.org>
In-Reply-To: <20091123083459.GB11443@elte.hu>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
	<20091116041407.GB5818@wotan.suse.de>
	<4B011677020000780001FD9D@vpn.id2.novell.com>
	<20091116105657.GE5818@wotan.suse.de>
	<20091119035640.GA18236@elte.hu>
	<20091118205240.11d3d660@infradead.org>
	<20091119081307.GA20534@wotan.suse.de>
	<20091119075958.2cba15f8@infradead.org>
	<20091123083459.GB11443@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 09:34:59 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Thu, 19 Nov 2009 09:13:07 +0100
> > Nick Piggin <npiggin@suse.de> wrote:
> > > 
> > > My other point was just this, but I don't care too much. But it is
> > > worded pretty negatively. The key here is that increasing the
> > > value too large tends to only cost a very small amount of size
> > > (and no increase in cacheline foot print, only RAM). 
> > 
> > 128 has a pretty significant impact on TPC-C benchmarks.....
> > it was the top issue until mainline fixed it to default to 64
> 
> Mind sending a patch that sets the default to 64 on NUMA too?
> 
> P4 based NUMA boxes are ... a bad memory to be forgotten.

this patch adds a regression. Linux defaulted to 64 since.. march or so.

now we go back to the old setting; Nick should fix that. Or at least
extremely document and justify this change....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
