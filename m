Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZIVHLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZIVHLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZIVHLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:11:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:53772 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbZIVHLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:11:11 -0400
Subject: Re: [PATCH v4 4/4] Use macros for .data.page_aligned section.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20090922044510.GB29208@merkur.ravnborg.org>
References: <1253484855-8067-1-git-send-email-tabbott@ksplice.com>
	 <1253484855-8067-5-git-send-email-tabbott@ksplice.com>
	 <1253576808.7103.167.camel@pasglop>
	 <20090922044510.GB29208@merkur.ravnborg.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 17:10:20 +1000
Message-Id: <1253603420.7103.203.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 06:45 +0200, Sam Ravnborg wrote:
> On Tue, Sep 22, 2009 at 09:46:48AM +1000, Benjamin Herrenschmidt wrote:
> > On Sun, 2009-09-20 at 18:14 -0400, Tim Abbott wrote:
> > > This patch changes the remaining direct references to
> > > .data.page_aligned in C and assembly code to use the macros in
> > > include/linux/linkage.h.
> > > 
> > > Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: H. Peter Anvin <hpa@zytor.com>
> > > Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> > 
> > Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Thanks for the ack Benjamin.
> I already sent a pull that includes this patchset - expect to land
> in mainline soon.
> The changes all looked trivially correct so I wanted it pulled
> so I could batch two of the kbuild stuff for this merge window.

That's ok, I've been a bit slow looking at it I'm afraid.

Ben.


