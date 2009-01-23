Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbZAWVwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbZAWVwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 16:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZAWVwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 16:52:25 -0500
Received: from mail.enyo.de ([212.9.189.167]:35036 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbZAWVwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 16:52:24 -0500
X-Greylist: delayed 2695 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2009 16:52:24 EST
From: Florian Weimer <fw@deneb.enyo.de>
To: linux-kernel@vger.kernel.org
Cc: DSA <debian-admin@lists.debian.org>, team@security.debian.org,
       libpam-modules@packages.debian.org
Subject: Re: 2.6.28, rlimits, performance and debian etch
References: <20090121115219.GA2754@anguilla.noreply.org>
Date: Fri, 23 Jan 2009 22:07:27 +0100
In-Reply-To: <20090121115219.GA2754@anguilla.noreply.org> (Peter Palfrader's
	message of "Wed, 21 Jan 2009 12:52:19 +0100")
Message-ID: <8763k5u3xs.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Palfrader:

> Turns out that script is forking a lot and something in it or python or
> whereever closes all the file descriptors it doesn't want to pass on.
> That is, it starts at zero and goes up to ulimit -n/RLIMIT_NOFILE and
> closes them all with a few exceptions.
>
> Turns out that takes a long time when your limit -n is now 2^20 (1048576).

Interesting.

Can we make /proc more-or-less mandatory, so that the file descriptor
list can be retrieved explicitly?
