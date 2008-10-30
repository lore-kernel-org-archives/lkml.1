Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbYJ3V4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbYJ3V4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYJ3Vz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:55:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:22633 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYJ3Vz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LDo2YH3TMw5PFzASUgBBWmrryf+Z/tGvmb8n60RX+NzylCQSPtMHkMNtYYIViDKbUy
         ycqSW2p/mmSRkTwBoJQfo0b1B8aJsQQu7EY98eZoh+ava9jaLqBiCb9KcSzg2GSHMajK
         yHkDDG2MA+GNyj6FkkP4bkVJNc5iP9uSG0QpI=
Date: Fri, 31 Oct 2008 00:49:10 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
Message-ID: <20081030214910.GA14679@x200.localdomain>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au> <20081023121145.GB27984@x200.localdomain> <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com> <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com> <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin> <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com> <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023163433.GA3160@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 08:34:33PM +0400, Alexey Dobriyan wrote:
> On Thu, Oct 23, 2008 at 07:27:48PM +0200, Frederic Weisbecker wrote:
> > When tracing is enabled, some arch have included <linux/irqflags.h>
> > on their <asm/system.h> but others like alpha or m68k don't.
> > 
> > Build error on alpha:
> > 
> > kernel/trace/trace.c: In function 'tracing_generic_entry_update':
> > kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'

FYI, this error still exists in mainline (7f82f000ed030d1108b4de47d9e2d556092980c6).
