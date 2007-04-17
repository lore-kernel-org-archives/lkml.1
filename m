Return-Path: <linux-kernel-owner+w=401wt.eu-S1031330AbXDRAAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031330AbXDRAAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 20:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031339AbXDRAAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 20:00:07 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:52046 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031330AbXDRAAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 20:00:05 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: AppArmor FAQ
Date: Tue, 17 Apr 2007 23:53:22 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f03mli$8g8$1@taverner.cs.berkeley.edu>
References: <20070416213350.GB4030@suse.de> <1176822230.3366.65.camel@localhost.localdomain> <462553A9.70504@novell.com> <1176852059.5946.128.camel@localhost.localdomain>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1176854002 8712 128.32.168.222 (17 Apr 2007 23:53:22 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Tue, 17 Apr 2007 23:53:22 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karl MacMillan  wrote:
>My private ssh keys need to be protected regardless
>of the file name - it is the "bag of bits" that make it important not
>the name.

I think you picked a bad example.  That's a confidentiality policy.
AppArmor can't make any guarantees about confidentiality.  Neither can
SELinux.  If you give a malicious app the power to read your private ssh
key, it's game over, dude.  (Covert channels, wall banging, and all that.)
So don't do that.

>Similarly, you protect the integrity of the applications that
>need name resolution by ensuring that the data that they read is high
>integrity. You do that by controlling data not the file name used to
>access the data. That is James point - a comprehensive mechanism like
>SELinux allows you to comprehensively protect the integrity of data.

I think this argument just misses the point.  What you want isn't what
AppArmor does.  Fine.  Nobody is forcing you to use AppArmor.  But that
doesn't mean AppArmor is useless.  There may be people who want what
AppArmor has to provide.

It sounds like you want a comprehensive information flow control system.
That's not what AppArmor provides.  If I understand correctly, one
thing AppArmor does provide is a way to confine untrusted legacy
apps in a restricted jail.  That can be useful in some scenarios.
Consider, for instance, a web server where untrusted users can upload PHP
scripts, and you're concerned that those PHP scripts might be malicious.
Maybe you'd like to confine the PHP interpreter to limit what it can do.
That might be a good application for something like AppArmor.  You don't
need comprehensive information flow control for that kind of use, and
it would likely just get in the way.

Those who want a information flow control system, will probably use
SELinux or something like it.  Those who want what AppArmor has to offer,
might well use AppArmor.  They solve different problems and have different
tradeoffs.  There is room for more than one security tool in the world.
