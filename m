Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbZHHUcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbZHHUcf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 16:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbZHHUce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 16:32:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40440 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbZHHUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 16:32:34 -0400
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: moving "tools" into the tools/ directory?
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LFD.2.00.0908081156210.9362@localhost>
Date: Sat, 08 Aug 2009 22:32:33 +0200
In-Reply-To: <alpine.LFD.2.00.0908081156210.9362@localhost> (Robert P. J. Day's message of "Sat, 8 Aug 2009 11:57:37 -0400 (EDT)")
Message-ID: <87bpmqt5b2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@crashcourse.ca> writes:

>   is there a standard for moving command-line tools into the top-level
> tools/ directory?  as in, Documentation/fs/slabinfo.c?  stuff like
> that?

I did some moving of such files from Documentation to tool in a git
tree some time ago, but to make it actually all build sanely --
especially with separate objdirs and/or cross compilation -- would
require major Makefile surgery first.

Current perf is a big pita for separate objdirs and cross compilation
already and it would be probably not a good idea to make it worse for
now.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
