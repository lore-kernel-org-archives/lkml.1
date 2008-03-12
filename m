Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYCLQra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYCLQra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYCLQrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:47:22 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:59638 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795AbYCLQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:47:21 -0400
Message-ID: <47D8091E.6030906@davidnewall.com>
Date: Thu, 13 Mar 2008 03:17:26 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, David Newall <davidn@davidnewall.com>,
       Jiri Kosina <jkosina@suse.cz>, "Fred ." <eldmannen@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz> <47D7B428.6010804@davidnewall.com> <20080312144701.GZ15804@mit.edu>
In-Reply-To: <20080312144701.GZ15804@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> The problem is that under heavy load the auto-repeat problem is real;
> I've seen it as well, and it means that I've started to try to avoid
> "make -j4" since that's a great way to trigger it.
>   

I'm sure it does suck under heavy load, although I suppose you could
increase the start time.  But I wonder if that is the problem this
time?  Modern machines are so damned fast they actually take real effort
to load.  Actually, "make -j4" doesn't sound particularly heavy. 
There's huge disk i/o in a make.  Plenty of scheduling opportunities. 
Obviously I only know what everybody else here knows; but with so many
recent posts suggesting a scheduling fault has been introduced, I'm
expecting it to be that.
