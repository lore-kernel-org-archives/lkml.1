Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYJTPzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYJTPzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYJTPzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:55:11 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60608 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYJTPzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:55:10 -0400
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based
	checkpointing/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: devel@openvz.org, containers@lists.linux-foundation.org,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200810201614.36911.major@openvz.org>
References: <1220439476-16465-1-git-send-email-major@openvz.org>
	 <1224286383.1848.65.camel@nimitz>  <200810201614.36911.major@openvz.org>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 08:55:05 -0700
Message-Id: <1224518105.1848.93.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 16:14 +0400, Andrey Mirkin wrote:
> Right now my patchset (v2) provides an ability to checkpoint and restart a 
> group of processes. The process of checkpointing and restart can be initiated 
> from external process (not from the process which should be checkpointed).

Absolutely.  Oren's code does it this way to make for a smaller patch at
first.  The syscall takes a pid argument so it is surely expected to be
expanded upon later. 

> Also I think that all the restart job (including process forking) should be 
> done in kernel, as in this case we will not depend on user space and will be 
> more secure. This is also implemented in my patchset.

Do you think that this is an approach that Oren's patches are married
to, or is this a "feature" we can add on later?

I don't care which patch set we end up sticking in the kernel.  I'm
trying to figure out which code we can more easily build upon in the
future.  The fact that Oren's or yours can't do certain little things
right now does not bother me.

Honestly, I'm a little more confident that everyone can work with Oren
since he managed to get 7 revisions of his patch out and make some
pretty large changes while in the same time the OpenVZ patch was only
released twice.  I'm not sure what has changed in the OpenVZ patch
between releases, either.

Are there any reasons that you absolutely can not use the code Oren
posted?  Will it not fulfill your needs somehow?  If so, could you
please elaborate on how?

-- Dave

