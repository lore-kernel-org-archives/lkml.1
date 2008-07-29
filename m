Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYG2CBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYG2CBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYG2CBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:01:09 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:41618 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYG2CBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SYJk8z09FRSU0WSc0pI/PsTelPpUAQP03sHLxZId5J/4HW3K0H0JU/l/VUyD0/tv5S
         +rv9h8AHTFtdt4vDZ553ug4XA5VgDtNG5iopWWCr/IJRzbaitLC13yODHowt/COLioLs
         0Dw+Bk5aMbXzM5zvF7INazYv5oq7zKGCxAyAI=
Message-ID: <9e4733910807281901i1a39ce93v902dd6bd240e1a34@mail.gmail.com>
Date: Mon, 28 Jul 2008 22:01:06 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: 463 kernel developers missing!
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080729013650.GG28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488DF9CF.8020408@simon.arlott.org.uk>
	 <488DFD97.7080802@simon.arlott.org.uk>
	 <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com>
	 <488E0BB6.7020006@simon.arlott.org.uk>
	 <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com>
	 <488E1147.5040803@simon.arlott.org.uk>
	 <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	 <20080729011526.GF28946@ZenIV.linux.org.uk>
	 <9e4733910807281825v42f9700al420ba48aebf3d790@mail.gmail.com>
	 <20080729013650.GG28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jul 28, 2008 at 09:25:39PM -0400, Jon Smirl wrote:
>  > On 7/28/08, Al Viro <viro@zeniv.linux.org.uk> wrote:
>  > > On Mon, Jul 28, 2008 at 03:00:13PM -0400, Jon Smirl wrote:
>  > >
>  > >
>  > > > Other people aren't perfect, I've found over 1,000 typos in the those
>  > >  > names and emails. We need a validation mechanism.
>  > >
>  > > Who's "we", luser, and why would I possibly give a damn for your needs?
>  >
>  > Let's drop the whole Sign-off-by mechanism. If we can't be bothered to
>  > clean up the junk in Signed-off-by why should we bother recording
>  > them? Sign every patch Mickey Mouse, it has the same effect.
>
> That still doesn't answer either of my questions.  As for your question, the
>  point is to have them good enough to make an individual changeset feasible
>  to track.

The file lets you convert the mess that exists in the log file xx-by:
fields back into something reasonable. The messed up email addresses
are verbatim extracted from the log. There is one entry in the file
for each email address that appears in the log. The real names have
been fixed by script and hand to correspond a real name with the
extracted emails.

Now we will differ on the definition of feasible and whether we should
work to prevent more messed up emails/names from getting into the log.
That's the central question here, how much are you allowed to
obfuscate (on purpose or accidentally) your identity in an xx-by?

I should also point out that external information (Google) was needed
to identify several hundred names, there was insufficient information
in the log or kernel source. If we have to reconstruct this mapping
ten years from now for some random lawsuit, the external information
may not be there.

-- 
Jon Smirl
jonsmirl@gmail.com
