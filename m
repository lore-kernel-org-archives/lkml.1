Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYCTKVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYCTKVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 06:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYCTKVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 06:21:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33103 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbYCTKVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 06:21:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Benjamin Thery" <ben.thery@gmail.com>
Subject: Re: [2.6.25-rc5-mm1] regression: cannot run Postfix sendmail command as non-root
Date: Thu, 20 Mar 2008 11:21:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "David Miller" <davem@davemloft.net>, akpm@linux-foundation.org,
       tilman@imap.cc, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pekkas@netcore.fi, yoshfuji@linux-ipv6.org, dlezcano@fr.ibm.com,
       xemul@openvz.org, ebiederm@xmission.com
References: <47D98510.60801@imap.cc> <20080319.154947.78332548.davem@davemloft.net> <939d53060803200126k563b9ae7l7197dea4e96ba1ed@mail.gmail.com>
In-Reply-To: <939d53060803200126k563b9ae7l7197dea4e96ba1ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803201121.07633.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 20 of March 2008, Benjamin Thery wrote:
> On Wed, Mar 19, 2008 at 11:49 PM, David Miller <davem@davemloft.net> wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> >  Date: Wed, 19 Mar 2008 14:16:08 -0700
> >
> >
> >  > Although this is advertised as a 2.6.25-rc5-mm1 problem, I assume the
> >  > regression is also in mainline? 2.6.25-rc6?
> >
> >  It is in 2.6.25-rc6, correct.
> >
> >  If Pavel or someone else doesn't produce a good fix soon
> >  I'll revert the guilty change as this bug is worse than
> >  the problem that changeset fixes.
> 
> Andre Noll sent a patch to LKML, acked by Pavel:
> 
> "Fix permissions of /proc/net"
> http://thread.gmane.org/gmane.linux.kernel/655148

Have you tested that patch?

Rafael
