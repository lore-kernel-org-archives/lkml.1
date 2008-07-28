Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYG1WIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYG1WIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYG1WIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:08:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:25404 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYG1WIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:08:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=plW+rgtJ35D59AIo01r/Dh7EcLjCxoSPSlAgB3ozhDz/wkMmYQI0GEhWbPq122FBTg
         v7RdW2AuUzJySFqvDptg3wHTKWQEwVipiEfryeM6HA7QTIG6X2+UCNffYeqb7NVZ9sSd
         2W5ByN5xvNYN8YxaIAEnJd+eRDJriD+j6FsI8=
Message-ID: <9e4733910807281508v5d348d53la59eeea8e2fabb67@mail.gmail.com>
Date: Mon, 28 Jul 2008 18:08:33 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Dave Jones" <davej@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       "Simon Arlott" <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: 463 kernel developers missing!
In-Reply-To: <20080728204624.GA11581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
	 <9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com>
	 <488DFD97.7080802@simon.arlott.org.uk>
	 <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com>
	 <488E0BB6.7020006@simon.arlott.org.uk>
	 <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com>
	 <488E1147.5040803@simon.arlott.org.uk>
	 <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	 <20080728202236.GN9378@mit.edu> <20080728204624.GA11581@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Dave Jones <davej@redhat.com> wrote:
> On Mon, Jul 28, 2008 at 04:22:36PM -0400, Theodore Tso wrote:
>   > On Mon, Jul 28, 2008 at 03:00:13PM -0400, Jon Smirl wrote:
>   > > Other people aren't perfect, I've found over 1,000 typos in the those
>   > > names and emails. We need a validation mechanism.
>   > >
>   >
>   > You keep using the word "need"; I do not think it means what you think
>   > it does.  :-)
>   >
>   > Seriously, why is it so important?  It's a nice to have, and I
>   > recognize that you've spent a bunch of time on it.  But if the goal is
>   > to get better statistics, and in exchange we forcibly map all Mark
>   > Browns to one e-mail address, and/or force them to all adopt middle
>   > initials (what if there are two Dan Smith's that don't have middle
>   > initials) just for the convenience of your statistics gathering, I
>   > would gently suggest to you that you've forgotten which is the tail,
>   > and which is the dog.
>
>
> I'm beginning to question just how useful the continued measuring
>  of things like Signed-off-by's is.   Last week at OLS, I overheard
>  a conversation where someone was talking about the "top 10" lists
>  that Greg has been talking about at various conferences.
>  The conversation went along the lines of "my manager really wants
>  to see us on that list, at any cost".

I didn't do this to measure statistics, I did it because I was writing
a script and the script was getting garbage for input. It just had the
side effect of cleaning up the statistics.

>  Whilst the naive may think 'more patches == more better', this isn't
>  necessarily the case given we have nowhere near enough review bandwidth
>  *now*, and flooding with a zillion trivial patches really isn't going
>  to make that job any easier.
>
>  Getting patches into the tree is easy, we've proven that.
>  As things stand now, it's also fairly easy to 'game' the system
>  by committing something in 10 changesets when it could be done
>  just as easily in 2-3.
>
>  How about we start measuring things that actually matter, like..
>
>  "How many patches were reviewed before they went in"
>  "How many patches were directly responsible for a bug"
>  "How many patches actually fixed something anyone cares about"
>  "How many patches are responsible for just 'churn'"
>

These are good topics for the Plumbers conference. But to ask these
questions we need to get the data into a format where a computer can
process it. Syntax checking, validation, etc are needed on the log
messages. I'm not going to hunt through 100,000 commits trying to
answer these by hand.

Another fun experiment would be to load an archive of LKML, kernel
bugzilla and the kernel source history into git and then try to link
everything together. The cleaner the data is, the easier it will be to
link things. How about a GUI where each patch is annotated with a link
to the email thread discussing it?

-- 
Jon Smirl
jonsmirl@gmail.com
