Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZHPAxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZHPAxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 20:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZHPAxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 20:53:36 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:51599 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZHPAxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 20:53:34 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Aug 2009 20:53:34 EDT
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: Security: information leaks in /proc enable keystroke recovery
Date: Sun, 16 Aug 2009 00:44:14 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <h67kou$ahr$1@taverner.cs.berkeley.edu>
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu> <20090816003326.GC7554@mit.edu>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1250383454 10811 128.32.168.222 (16 Aug 2009 00:44:14 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 16 Aug 2009 00:44:14 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso  wrote:
> A configuration option which defaults to disabling ESP and EIP would
> be a simple way to prevent this specific instance of information
> leakage.  The problem is there are other files that might reveal
> timing information, but which are very useful for a system
> administrator.  A key example of this is /proc/$pid/wchan, which is
> responsible for the WCHAN column is a ps listing.

If they're useful for system administrators, would making them
readable to root (but not everyone) be enough?
