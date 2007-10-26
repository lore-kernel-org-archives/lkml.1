Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbXJZFo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbXJZFo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXJZFoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:44:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:17955 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbXJZFoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F6Mf3cibJ7e+vkSQxbny4EKCTZhZALXXAxmoF0jRsx5EtwO1tRNk+k5U/EcWidYOSthtKd7SJVFy/rC8cdZuJ5RKqp63KyCneZI4pb/p+4wwms8klo7WMGxy9peEgKiC8lsCJ236v7h9m2hY5W0rUG0v+iD8NvAjRpgLqgN0ajo=
Message-ID: <e7d8f83e0710252244y46744aaemca838f8431973ae8@mail.gmail.com>
Date: Fri, 26 Oct 2007 15:44:17 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
In-Reply-To: <Pine.LNX.4.64.0710252042250.21140@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024223124.GI30533@stusta.de>
	 <446110.89443.qm@web36608.mail.mud.yahoo.com>
	 <20071025002356.GB3660@sequoia.sous-sol.org>
	 <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
	 <20071025024131.6082e4a8@the-village.bc.nu>
	 <2c0942db0710251117k37c30b2ex5cc6d8cd8c9ea029@mail.gmail.com>
	 <20071025232150.25d6e5bd@the-village.bc.nu>
	 <Pine.LNX.4.64.0710252042250.21140@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok lets get to a good point.

Lets define a key bit.   What is a good software security lock?

My define is that its available to be used everywhere its needed and
when ever its need without flaw.

This is where most LSM fall in a heap.  Because you have to have the
LSM loaded to have its security features and cannot always be mixed
with other LSM it failes the when ever it is needed test.

On top of this most LSM features don't provide any form of direct
control to non admin users or applications to lower there access
rights.  So it also fails to be used everywhere its needed.

Since the LSM design itself is flawed in my eyes.   These flaws make
it hard for LSM to share tech advantages with each other.   LSM are
very much like putting a lock threw the front wheel of a bike.   So
the thief removes the front wheel and walks off with the rest of the
bike.  The critical data is in the user accounts.

The big thing with most LSM how do they handle security inside a
application on a thread by thread base.  They don't reason it gets too
compex without known the internals of the application.

We are talking security here and design of LSM's are not offering the
option max security.

Max security has to get down to a single thread inside a application
with all the security blocking features LSM's offer.  Reason a flaw in
that thread could be made completely harmless even that the other
threads in the application has complete system rights.

Idea of Max is to keep application flaws to as minor security flaw as
they could have been.   Ie Hopefully no risk because the flaw happened
in a section of code with no rights.

This is virtually imposable for any form of profiling creating
security to ever do(LSM profile based security).  What is needed is
application controlled security with profile based security as fail
back.  I know this means ripping your LSM parts apart and designing in
application controls.  Allowing features to be shared between LSM and
even to be there when the LSM that feature came from is not being
used.

First goal should not be to get a LSM static linked into kernel or
anything else bar getting the security system to a point that max
security is on the table if people want it.

I will say this again in my eyes LSM's should be thrown out of the
kernel completely because they are only offering fake max security.
Selinux and other LSM's on max is not even close to what should be
offered.

Basically Linux is a sitting duck for data thief third party  that
steal from the users home directory personal information.   And its
not like application developers are being given the tools to prevent
that.  Cost and loss does not start only when applications normal
profile of access is breached.   It starts way before that.

Peter Dolding
