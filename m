Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZIVEpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZIVEpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 00:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZIVEpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 00:45:13 -0400
Received: from [195.41.46.236] ([195.41.46.236]:34545 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZIVEpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 00:45:12 -0400
Date: Tue, 22 Sep 2009 06:45:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v4 4/4] Use macros for .data.page_aligned section.
Message-ID: <20090922044510.GB29208@merkur.ravnborg.org>
References: <1253484855-8067-1-git-send-email-tabbott@ksplice.com> <1253484855-8067-5-git-send-email-tabbott@ksplice.com> <1253576808.7103.167.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253576808.7103.167.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 09:46:48AM +1000, Benjamin Herrenschmidt wrote:
> On Sun, 2009-09-20 at 18:14 -0400, Tim Abbott wrote:
> > This patch changes the remaining direct references to
> > .data.page_aligned in C and assembly code to use the macros in
> > include/linux/linkage.h.
> > 
> > Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Thanks for the ack Benjamin.
I already sent a pull that includes this patchset - expect to land
in mainline soon.
The changes all looked trivially correct so I wanted it pulled
so I could batch two of the kbuild stuff for this merge window.

	Sam
