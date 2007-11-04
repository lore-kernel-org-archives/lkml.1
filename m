Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbXKDR6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbXKDR6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 12:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbXKDR60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 12:58:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbXKDR6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 12:58:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18222.2107.914484.284023@zebedee.pink>
Date: Sun, 4 Nov 2007 17:58:19 +0000
From: Andrew Haley <aph@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tomash Brechko <tomash.brechko@gmail.com>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <alpine.LFD.0.999.0711040943540.15101@woody.linux-foundation.org>
References: <18210.2314.57767.962503@zebedee.pink>
	<MDEHLPKNGKAHNMBLJOLKCELIHMAC.davids@webmaster.com>
	<18215.1394.294830.944162@zebedee.pink>
	<e2e108260711020829p5994f79bp48ca35a1ce84ff03@mail.gmail.com>
	<18219.17505.443550.620503@zebedee.pink>
	<e2e108260711040713g2802b262sda75672f8e0f50f6@mail.gmail.com>
	<alpine.LFD.0.999.0711040943540.15101@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 22.0.93.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:
 > 
 > 
 > On Sun, 4 Nov 2007, Bart Van Assche wrote:
 > > 
 > > Has it already been decided who will do this audit, and when this
 > > audit will happen ? Has a target date been set when this audit
 > > should be complete, or is the completion of this audit a
 > > requirement for the release of a specific gcc version ?
 > 
 > I am told that the gcc people realized that was indeed a bug
 > (people were able to show problems even in non-threaded
 > environments with mprotect()), and have now fixed it in the current
 > gcc sources. That still leaves the old versions with potential
 > problems, but I think it makes it much less interesting to audit
 > for these things.

We're back-porting the patch to all open branches.  However, this
patch only affects one paticular case where gcc introduces a data
race; we're sure there are others not fixed.

Andrew.

-- 
Red Hat UK Ltd, Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, UK
Registered in England and Wales No. 3798903
