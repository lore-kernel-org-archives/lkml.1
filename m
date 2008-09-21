Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbYIUMxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbYIUMxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 08:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYIUMxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 08:53:34 -0400
Received: from web32604.mail.mud.yahoo.com ([68.142.207.231]:44353 "HELO
	web32604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751475AbYIUMxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 08:53:33 -0400
X-YMail-OSG: iidae6QVM1kORcAgbqqjVy8Btr4W7c5xRugfRsA7ViqGAi0vnmAhGAWOeO7fBC04C7SASaR1Z_FlToJUq7j7o8yWwzHG0aj0rTAm0Ymgsya9jJBvBD9akyh9nWRhJxFtBk5c3EFE
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Sun, 21 Sep 2008 05:53:32 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
To: Peter Staubach <staubach@redhat.com>, Chuck Lever <chucklever@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Banks <gnb@melbourne.sgi.com>,
       linux-nfs list <linux-nfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <614333.44648.qm@web32604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> >
> > I agree that a mount option would allow more fine-grained control over
> > readahead.  A system wide parameter controlling readahead has always
> > been a weakness.  Readahead, as implemented in the VFS, has a
> > *per-file descriptor* context, however, which operates automatically
> > (and can be tuned at run-time by an application with [mf]advise(2).
> >
> > As a future feature, this might work in better combination with the
> > per-mount bdi changes proposed by Peter to provide maximal flexibility
> > without exposing yet another confusing knob that could help some
> > workloads but hurt others.
> 
> And perhaps add some dynamic tuning capabilities to the NFS client
> code to just make it do "the right thing".  This would be better
> than any tunables and would help to serve in other situations, such
> as high bandwidth/latency networks, overloaded servers who don't
> need more read-ahead READ requests piled on, etc...
> 

 this goes over my capabilities, but would certainly help the situation. But then I would hate to see Sun/Linux going off the hook, because Linux just played nice :-)

Cheers
Martin

