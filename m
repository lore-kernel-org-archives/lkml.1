Return-Path: <linux-kernel-owner+w=401wt.eu-S1760361AbYDXRPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361AbYDXRPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbYDXRPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:15:33 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36855 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYDXRPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:15:32 -0400
Date: Thu, 24 Apr 2008 13:14:00 -0400
Message-Id: <200804241714.m3OHE0Ua014682@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ezk@cs.sunysb.edu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts 
In-reply-to: Your message of "Thu, 24 Apr 2008 18:58:16 +0200."
             <E1Jp4m0-0004UU-3G@pomaz-ex.szeredi.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <E1Jp4m0-0004UU-3G@pomaz-ex.szeredi.hu>, Miklos Szeredi writes:
> > Sure, unionfs already does some of it now (and some of it can be recoded
> > more cleanly), but I'd like to get rid of much of it if I could -- these new
> > path_* helpers make me have to maintain vfsmounts even moreso than before.
> 
> With the words of Al: "that is hogwash".  Stacks either maintain
> vfsmounts or they don't.  There's no middle ground.

So, if I wanted to not maintain vfsmounts at all in unionfs, how can I use
the proposed new path_* helpers which require vfsmounts?  Will there be some
other helpers available to perform lower-filesystem operations (e.g., mkdir,
create, unlink, etc.) which won't require passing vfsmounts?

The "or they don't" is not much of an option when I'm forced to use an API
that requires a vfsmount...

> Miklos

Thanks,
Erez.
