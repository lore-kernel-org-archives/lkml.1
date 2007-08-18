Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbXHRUdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbXHRUdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 16:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXHRUcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 16:32:52 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:51829 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbXHRUcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 16:32:51 -0400
Date: Sat, 18 Aug 2007 13:32:30 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt
	issue
Message-ID: <20070818203230.GV3672@sequoia.sous-sol.org>
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org> <200708181149.48217.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708181149.48217.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> > This patch breaks Xen booting.  
> 
> Check the latest git head. Does it still break?

Yeah, this is the latest git.  The broken commit is Rusty's patch which,
after Linus reverted the write-protected remap changes, is no longer
necessary.  AFAICT patching is writing garbage into the insn stream.
I suspect it's copying an uninitialized temp buffer.

thanks,
-chris
