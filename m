Return-Path: <linux-kernel-owner+w=401wt.eu-S1765056AbYBUNX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765056AbYBUNX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYBUNXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:23:17 -0500
Received: from mail.macqel.be ([194.78.208.39]:6793 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbYBUNXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:23:16 -0500
X-Greylist: delayed 2076 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 08:23:16 EST
Date: Thu, 21 Feb 2008 13:35:34 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: POWERPC : What's "SPE used in kernel" ?
Message-ID: <20080221123534.GA17716@ingate.macqel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

I have just compiled linux-2.6.24 for a MPC8540 target using a MPC8540
specific gcc.

I then got thousands of "SPE used in kernel" messages.  Looking at the
sources I ifdeffed out the printk call in KernelSPE, and I now have a
silent kernel, that seems to work fine.

Is there something wrong in my setting and should I look further to
debug this problem or is this perfectly normal ?

I wonder why a kernel configured for E500 using a E500-specific gcc
triggers this message.  Is it invalid to use SPE instructions in the kernel ?

Philippe
