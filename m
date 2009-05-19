Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZESXYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZESXYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 19:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbZESXYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 19:24:42 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:57424 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZESXYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 19:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RnKpPJkd5sJwDJyR+xnsfJXCURqogF4DWkyG8u6wUVcRpMyRW7y937s0EbbAKitkA0
         xKVKaNNTeXL3rVbGw8XMGJ68z43mcNQ6RzV2hvNTfJO7e20LW8O7uTOR0gB+wdBJ1Quy
         nEvGnglZndiyqN8la8ltZx53hD0ShrO4HRpvU=
Date: Wed, 20 May 2009 01:24:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 0/2] Improvements and fixes to HW Breakpoint interface
Message-ID: <20090519232437.GB6066@nowhere>
References: <20090519162353.GA26009@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519162353.GA26009@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 09:53:53PM +0530, K.Prasad wrote:
> Hi Alan,
> 	Please find a couple of patches that contain improvements to the HW Breakpoint
> interface code (discovered while porting the infrastructure on another architecture)
> and a minor fix - the details of which are described in the patch header.
> 
> These patches can be applied over the patchset submitted over -tip here:
> http://lkml.org/lkml/2009/5/15/139.
> 
> As they carry some of your suggestions, I will be glad to have it reviewed by you.
> 
> Hi Frederic,
> 	There's a minor style issue in the ksym tracer plugin (declaration of a
> function in .c file) which has now been corrected. Kindly review the same.



The ftrace part looks good, indeed such style issue is usually warned by checkpatch.pl
Thanks.

Ingo,

What do you think of the current state of the hardware breakpoint patchset?
If I'm not wrong, it has not yet been applied in -tip. Do you have mixed
feelings about it?
IIRC it has been mostly (fully?) acked by Alan Stern, I've also reviewed
the ftrace patch.

Frederic.

