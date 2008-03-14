Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYCNFXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYCNFXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbYCNFWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:22:00 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:59996 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758527AbYCNFV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:21:59 -0400
Message-ID: <47DA0B78.8010802@davidnewall.com>
Date: Fri, 14 Mar 2008 15:52:00 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803131214.40321.phillips@phunq.net> <20080313162711.3d483e6c@cuia.boston.redhat.com> <200803131923.14840.phillips@phunq.net>
In-Reply-To: <200803131923.14840.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to seem some science.  I'd like to know how much faster it
really is, and for that proper testing needs to be done.  Since Daniel's
scheme uses the same amount of RAM as disk, an appropriate test would be
to pin (at least) that amount of RAM to buffer cache, and then to fill
the cache with the contents of the disk (i.e. cat /dev/disk >
/dev/null.)  This sets the stage for tests, which tests should not
include the sync operation.  I'd like to see actual numbers against such
a setup versus Daniel's scheme.  Since buffer cache is shared by all
disks, obviously the test must not access any other drive.

One thing I will admit: RAM disks are fast.  What I don't know is how
much work there is to access blocks that are already in the buffer
cache.  In principle I suppose it should be a little slower, but not
much.  I'd like to know, though.  I'd do the test myself if I had a
machine with enough RAM, but I don't.  Daniel (apparently) does...
