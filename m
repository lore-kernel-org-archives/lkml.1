Return-Path: <linux-kernel-owner+w=401wt.eu-S966417AbXEVR7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966417AbXEVR7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbXEVR7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:59:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:24469 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830AbXEVR7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:59:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dqD1wZ4/pXo2fJ6tl9zSw+zpMvWLGrAjlXFeTGXVIZooJjcSQyTpOTYbMeLWRde9E7v5UNsdm5+LMpBcndQODnVJ+a1ZfXbJdyXcyohNmzzfdpAafIMFFoDWHvFWoTON/oFlO8sXjj7QU9Z5JZp93KDYiHDqoX3BQwwDy3a6Dv4=
Message-ID: <a781481a0705221059g31f7eea6na0f23d7d98dc3dc4@mail.gmail.com>
Date: Tue, 22 May 2007 23:29:01 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>, "Adrian Bunk" <bunk@stusta.de>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <46532E49.6020402@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <46504876.9040802@s5r6.in-berlin.de>
	 <a781481a0705200650v2ef7be85h19f8c8eb026a303b@mail.gmail.com>
	 <46505DBD.5010005@s5r6.in-berlin.de>
	 <a781481a0705220753g25bb0dd8u33bbf8ddaf00f50c@mail.gmail.com>
	 <46532247.6030803@s5r6.in-berlin.de>
	 <a781481a0705221013m45f82054tca9a9a78ea8935d4@mail.gmail.com>
	 <46532AA4.6080501@s5r6.in-berlin.de>
	 <a781481a0705221046p6d94a652k3081eacdba01ca8d@mail.gmail.com>
	 <46532E49.6020402@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Satyam Sharma wrote:
> > On 5/22/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> When I said "The standard and maintainable way (for drivers at least)
> >> is..." I didn't mean the example expression, I meant the *direction* in
> >> which the example was stating dependencies.
> >
> > In that case I wish "the points" you make on threads are relevant to them.
>
> My initial reply was on a patch which removed the A-to-B declaration of
> dependency.

And if you think you can have the "direction of declaration of
dependencies" the way you like it, and also (1) preserve current
"select"-like behaviour, (2) introduce no build issues, and (3) get rid of
the bogus warnings, then: Patches are welcome. (No, suggestions that
don't work, or not fully applicable to the case at hand in this thread will
NOT do).
