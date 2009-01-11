Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZAKPPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZAKPPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZAKPPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:15:40 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:34524 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbZAKPPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:15:39 -0500
Subject: Re: multiple bugs
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: w.landgraf@yahoo.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <929931.34382.qm@web112216.mail.gq1.yahoo.com>
References: <929931.34382.qm@web112216.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=utf-8
Date: Sun, 11 Jan 2009 16:17:29 +0100
Message-Id: <1231687049.17759.12.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please use reply-to-all in order not to break threading, it makes it a
 pain for everyone that tries to follow the discussion.)

søn, 11 01 2009 kl. 06:46 -0800, skrev We La:
> 1) More exactly, with all kernels since 2.6.27 -rcX until now, on attempts
> on about 10 machines, I don't get connection or data transfer. Thus I
> think it's not a regression on particular eth drivers, but perhaps on
> the routing or package handling.   On my original message, I gave the
> config for one of these kernels.  Below I give, for comparison, the
> config of 2.6.26.2 with which it still was working.  I have no idea
> which of the differences of the config, or new features, can cause
> this problem.

How do you generate the config for 2.6.27-* and the other versions that
fail? You should normally just use the .config for 2.6.26.2 or whatever
you used last and run 'make oldconfig' selecting the default answer to
each new option unless you have a good reason not to and have read and
understood the help text that goes along with the option. This way you
wouldn't have run into the problem with kernel mode setting either.

And still, even if it is not a problem with a network driver but in
another part of the network layer etc. a bisection run would be a good
way to pinpoint the issue. But see if it is not your config that causes
the problem first.


Simon Holm Thøgersen

