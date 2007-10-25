Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbXJYB0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbXJYB0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXJYB0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:26:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:65519 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbXJYB0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:26:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mXzjggZib0Eek72cWq6GV0T3liS9QkFVPIc48Xgq/hiOMbFnWwFPSiRX8hMrxNKyyFxxxRJmH+lCgAasu4u9owV1vgAb4sTk1uZufHxqGfKiHkq4U1nxvY4AUwZrZBkU6F3DL4lbiBNXpUJLZmjJWSUQVJFFKAQVnA7N3KEuGwQ=
Message-ID: <e7d8f83e0710241826q636bb5acwd268ec062eeb3370@mail.gmail.com>
Date: Thu, 25 Oct 2007 11:26:07 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
In-Reply-To: <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024223124.GI30533@stusta.de>
	 <446110.89443.qm@web36608.mail.mud.yahoo.com>
	 <20071025002356.GB3660@sequoia.sous-sol.org>
	 <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have different deal breakers.

If a LSM is something simple/commonly required it should be made like
posix file capability's provided to all to use.   Sorry to say I see
the file protection in apparmor as something everyone should be able
to use at will like posix file capability's.  All enforcement features
should be common.

I see a LSM as a director commander its reason for existence is to
read security configs and hand them permissions and respond to
problems.   Any enforcement should be default in kernel.

So LSM could be roll based, mac or any other model.  Current problem
enforcement and guiding are mixed up in one block.  So evolution is
not happening.

The enforcing bits of LSM's should be a simple no brainier addons to
the Linux kernel.  The problem is at moment they are mixed up with Mac
....  A security model to use has to be picked to suit job.   Role
Based can be Better than Mac and Mac can be better than Role based.
It all depends on what you are defending.

Thing common all need to protect suid, file access, network access...
The bits you need to defend don't change if or if not you are running
a LSM.  So why are these bits bottled up inside LSM forcing people to
choose the wrong security model for there task to get protection at
times.

There can never be one LSM to do every job.   But the big but all the
common bits to protect every job could be in kernel.  Only thing
missing is the director.

This is exactly the same problem Virtual Server solutions had when
then wanted to get into the kernel.   At least the Virtual Server
solutions were not as pig headed as some of the LSM guys about it.
Where its all in or not in at all.   Little bits into kernel is better
than nothing.

Really this will sound bad if I had my way I would kick all LSM's out
of the main kernel tree until they learn to work with each other to
share bits.  We don't need 10 copies of protect files from access.  Or
10 copies of limit what .so a application and interface with and so
on.

It worked with Virtual Servers to get them to sit down and start
talking.  What we really need working on is system wide security.  No
bothering a lot about the little box of LSM.

Yes I am not nice to LSM.   I see them as bitrot.  They are going to
cause containers problems in there current form as containers evolve.
They are not improving the base line security level.  Yes selinux
saying make me default to improve secuity says that in selinux there
are parts that should be chopped out and made default.  But since it
contains a security model it cannot be all made default because it
just will not fit everywhere.

Basically a LSM should make it simpler to run security tight.  The big
all mighty but it should not alter achievable security.  If its
altering achievable security main kernel is missing features and
someone needs to slice and dice that LSM.

Peter Dolding
