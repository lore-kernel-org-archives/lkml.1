Return-Path: <linux-kernel-owner+w=401wt.eu-S933107AbYEHTAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbYEHTAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbYEHTAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:00:13 -0400
Received: from flatoutfitness.com ([66.178.130.209]:60275 "EHLO www.seiner.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607AbYEHTAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:00:08 -0400
Message-ID: <50279.199.79.32.17.1210273206.squirrel@www.datavault.us>
In-Reply-To: <20080508185221.GA4090@atrey.karlin.mff.cuni.cz>
References: <4814DBFA.2070901@seiner.com>
    <20080508185221.GA4090@atrey.karlin.mff.cuni.cz>
Date: Thu, 8 May 2008 12:00:06 -0700 (PDT)
Subject: Re: Kenrel oops
From: "Yan Seiner" <yan@seiner.com>
To: "Jan Kara" <jack@suse.cz>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jan Kara
>> I just had this kernel oops.  Approximately 5 mintes later, the machine
>> hard-locked.  Can anyone give me some guidance on where to look?
>   Any chance of reproducing this without the NVidia module? It looks
> like filp->f_op->flush contained an invalid pointer (although
> ffff81007e3d1300 doesn't look completely insane but more like a pointer
> to data than to a function). Weren't you playing with rmmod before this
> happened?

I was playing with Xephyr on top of X, so it's possible that the script I
was using tried to load the opensource nv module on top of the nvidia
module and/or that there was repeated insmod/rmmod of nvidia and nv before
this happened.

I've not been able to reproduce this since.

--Yan


-- 
Windows is like a canary in a coal mine, it's the first thing to die on
your network.

