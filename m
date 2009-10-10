Return-Path: <linux-kernel-owner+w=401wt.eu-S1762142AbZJJVZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762142AbZJJVZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 17:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbZJJVZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 17:25:46 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:33548 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758574AbZJJVZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 17:25:46 -0400
Date: Sat, 10 Oct 2009 22:25:05 +0100
From: Ben Dooks <ben@fluff.org>
To: linux-kernel@vger.kernel.org
Subject: make mrproper not resetting kernel saved arch
Message-ID: <20091010212505.GA7793@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having accidentally configured for the wrong arch, I tried going back to ARM
but got the following errro:

Makefile:210: *** ARCH changed from "x86_64" to "arm". Use "make mrproper" to fix it up.  Stop.

Trying to do 'make mrproper' repeats the error:

$ make mrproper
Makefile:210: *** ARCH changed from "x86_64" to "arm". Use "make mrproper" to fix it up.  Stop.

I ended up doing 'rm -r include/generated' to get rid of this.

My makefile understanding isn't good enough to repair this, so can someone
please fix this.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
