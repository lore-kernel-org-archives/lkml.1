Return-Path: <linux-kernel-owner+w=401wt.eu-S932687AbXBOFQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbXBOFQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 00:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932688AbXBOFQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 00:16:31 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:35678 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687AbXBOFQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 00:16:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CZD1EigBhWn5NmhgzuDozM46NedyN+gdx2LxA7ZZoZMA4wNsC1EsixglteQ+U8wsqFCcTVxxnShVfR0pfzP/t3r6FaydxqIw2pP+wFo8W8jHAF494SFjUwq4uD6WGyMWXzGM5kvGPlFj2wWII2TFToZklZtqGkUCGAqVLThZsFQ=
Message-ID: <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
Date: Wed, 14 Feb 2007 21:16:28 -0800
From: "v j" <vj.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: GPL vs non-GPL device drivers
In-Reply-To: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is in reference to the following thread:

http://lkml.org/lkml/2006/12/14/63

I am not sure if this is ever addressed in LKML, but linux is _very_
popular in the embedded space. We (an embedded vendor) chose Linux 3
years back because of its lack of royalty model, robustness and
availability of infinite number of open-source tools.

We recently decided to move to Linux 2.6 for our next product, mainly
because Linux has worked so well for us in the past, and we would like
to move up to keep up with the latest and greatest.

However in moving to  2.6, we noticed a number of alarming things.
Porting drivers over from devfs to udev, though easy raised a number
of alarming issues. Driver's no longer could dynamically allocate
their MAJOR/MINOR numbers. Doing so would mean they would have to use
sysfs. However it seems that sysfs (and the class_ interface) is only
available to GPL modules. This is very concerning. The drivers which
we have written over the last three years are suddenly under threat.
We don't mind statically assigning MAJOR/MINOR numbers to our drivers.
We can do this and modify our user space applications too.

However we have a worrying trend here. If at some point it becomes
illegal to load our modules into the linux kernel, then it is
unacceptable to us. We would have been better off choosing VxWorks or
OSE 3 years ago when we made an OS choice. The fact that Linux is
becoming more and more closed is very very alarming.

vj.
