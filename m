Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbYG1Ui0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbYG1Ui0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYG1UiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:38:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:53668 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYG1UiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ToV7erUVHp9ptvM4JJ/MX7eTAzNPRTVoGevBfZSm55dX6PaJw9bWmF8BDHOtlk6KR1
         6oSlLdsf6qQHwxuquB/pZCMIx9wdhEhfodK9kpksGqZSueiMrRlDJDexDF0ym0nKfOds
         ch8F2BioDuYJvK08L4CHYvTjJgaejtD4YZ2mE=
Message-ID: <9e4733910807281338o229e7736gb164ad01ff0b2448@mail.gmail.com>
Date: Mon, 28 Jul 2008 16:38:15 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Jon Smirl" <jonsmirl@gmail.com>,
       "Simon Arlott" <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
In-Reply-To: <20080728202236.GN9378@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
	 <488DF9CF.8020408@simon.arlott.org.uk>
	 <9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com>
	 <488DFD97.7080802@simon.arlott.org.uk>
	 <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com>
	 <488E0BB6.7020006@simon.arlott.org.uk>
	 <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com>
	 <488E1147.5040803@simon.arlott.org.uk>
	 <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	 <20080728202236.GN9378@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Jul 28, 2008 at 03:00:13PM -0400, Jon Smirl wrote:
>  > Other people aren't perfect, I've found over 1,000 typos in the those
>  > names and emails. We need a validation mechanism.
>  >
>
>
> You keep using the word "need"; I do not think it means what you think
>  it does.  :-)
>
>  Seriously, why is it so important?  It's a nice to have, and I
>  recognize that you've spent a bunch of time on it.  But if the goal is
>  to get better statistics, and in exchange we forcibly map all Mark
>  Browns to one e-mail address, and/or force them to all adopt middle
>  initials (what if there are two Dan Smith's that don't have middle
>  initials) just for the convenience of your statistics gathering, I
>  would gently suggest to you that you've forgotten which is the tail,
>  and which is the dog.

There are over 1,000 typos in the logs. No validation being done on
the names/addresses in the logs. Many email addresses aren't
syntactically valid. Why not put some checks in place to try and clean
this up? Signed-off-by is worthless if it is full of garbage.

The are two Mark Browns in the file:
Mark Brown <broonie@opensource.wolfsonmicro.com>
Mark Brown <broonie@sirena.org.uk>

I don't know if these are two different people or one person with two
emails. But the file doesn't force that decision. It's git shortlog
that is combining them.

The file serves two purposes:
Map people using multiple email aliases a human single name, It can be
any name they choose. Existing file already does this but the list is
not complete.
Enumerate all email addresses used in the log so that it is possible
to tell when a new address is encountered. Allows simple validation to
be implemented.

In it's current form it doesn't indicate which aliases is the
developer's currently active one.

-- 
Jon Smirl
jonsmirl@gmail.com
