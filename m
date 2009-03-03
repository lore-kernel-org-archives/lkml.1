Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZCCUdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZCCUdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZCCUdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:33:37 -0500
Received: from hera.cwi.nl ([192.16.191.8]:60426 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZCCUdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:33:36 -0500
X-Greylist: delayed 1661 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Mar 2009 15:33:36 EST
Date: Tue, 3 Mar 2009 21:05:31 +0100
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: linux-kernel@vger.kernel.org
Subject: ext3 duplicate entries with readdir
Message-ID: <20090303200526.GA20236@ub>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a largish directory (21292 files) a scan using ext3 readdir
found 21293 files, returning one entry twice.

Google "ext3 readdir twice" gives me a handful of identical complaints.
I see reports from 2002-2008.
So, this is an old and well-known symptom but seemingly still not fixed,
at least not in the kernel on this machine here.
This report is for Fedora release 8 (Werewolf) with kernel 2.6.24.5.

A 2002 post says "This is unfortunate, but the chances of our hitting
this failure are relatively small".

In http://www.redhat.com/archives/ext3-users/2008-August/msg00009.html
tytso seems to understand what happens: a hash collision.
But has this been fixed in the current tree?


Andries


Thomas Trauner gave a test program. It prints
expected 25989 files, but readdir reports 25990

So, yes, this is reproducible.


