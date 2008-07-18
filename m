Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYGRP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYGRP5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbYGRP5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:57:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:4516 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYGRP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:57:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=R4DEDaCwlke8R7uoDb5doDHC8SlHWwaaQ8TVzkU9aHay6pJ43eH+ui+tE+2Znex2hy
         Zu6l4tlmTBhAX/jdljnURIKu/6pNnlw6+skz1BO4TaBu8twUIWeU1Ju7ste2+ZMvPpKM
         F8rgVLLcD12phyqbTaLn5PQSKLf4U5nKtRicE=
Message-ID: <2c0942db0807180857v54748277ja4b330537309a861@mail.gmail.com>
Date: Fri, 18 Jul 2008 08:57:08 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Olivier Galibert" <galibert@pobox.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@linuxfoundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <20080718132521.GA94799@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807161633.01375.jbarnes@virtuousgeek.org>
	 <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>
	 <487F71E8.9050705@firstfloor.org>
	 <2c0942db0807171211s39e2653fwdc50f92d9c3020d2@mail.gmail.com>
	 <487FA24B.9060803@firstfloor.org>
	 <alpine.LFD.1.10.0807171259010.2959@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807171304220.2959@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807171323320.2959@woody.linux-foundation.org>
	 <20080718132521.GA94799@dspnet.fr.eu.org>
X-Google-Sender-Auth: 22805bc3d60c0e0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 6:25 AM, Olivier Galibert <galibert@pobox.com> wrote:
> You say "don't rebase on the most recent kernel version".  Andi seems
> to accept that going forwards.  You say "use topic branches that are
> based on whatever kernel version you had at the time, I'll do the
> merge".  That's ok too.  His remaining question is "what do I do with
> broken patches _in_the_topic_branch_?".  He wants to
> amend/merge/split/reorder within the topic branch so that the branch
> itself is bisectable.  So what should be done there?

If the patches have problems, then make a new topic branch and redo
them there, or reorder, amend, squash, whatever inside the original
branch. The problem comes once you open that branch out for other
people to pull from, or if that branch had pulled patches from someone
else. At that point you're destroying the history that other people
are now already sharing, in a meta-data sense (changing the sha1), as
well as invalidating whatever test points that people may have had on
those commits.

In short, don't rewrite public history. If you want to share out your
works-in-progress, just let people know that those branches of yours
are volatile and not to be trusted. But you can't pull someone else's
public history, and then make it volatile; subtle trouble ensues.
