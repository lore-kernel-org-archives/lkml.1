Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbXAWBLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbXAWBLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932482AbXAWBLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:11:06 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:53002 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932461AbXAWBLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:11:05 -0500
Date: Tue, 23 Jan 2007 12:10:52 +1100
From: David Chinner <dgc@sgi.com>
To: Stefan Priebe - FH <studium@profihost.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: XFS or Kernel Problem / Bug
Message-ID: <20070123011052.GD33919298@melbourne.sgi.com>
References: <20060801143803.E2326184@wobbly.melbourne.sgi.com> <44CF36FB.6070606@profihost.com> <20060802090915.C2344877@wobbly.melbourne.sgi.com> <44D07AB7.3020409@profihost.com> <20060802201805.A2360409@wobbly.melbourne.sgi.com> <45B35CD7.4080801@profihost.com> <20070122061852.GT33919298@melbourne.sgi.com> <45B46CEE.4090808@profihost.com> <20070122080306.GW33919298@melbourne.sgi.com> <45B470BB.8000208@profihost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B4870C.9080108@profihost.com> <45B470BB.8000208@profihost.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 09:07:23AM +0100, Stefan Priebe - FH wrote:
> Hi!
> 
> The update of the IDE layer was in 2.6.19. I don't think it is a 
> hardware bug cause all these 5 machines runs fine since a few years with 
> 2.6.16.X and before. We switch to 2.6.18.6 on monday last week and all 
> machines began to crash periodically. On friday last week we downgraded 
> them all to 2.6.16.37 and all 5 machines runs fine again. So i don't 
> believe it is a hardware problem. Do you really think that could be?

I was thinking more of a driver change that is being triggered on
that particular hardware. FWIW, did you test 2.6.19?

I really need a better idea of the workload these servers are running
and, ideally, a reproducable test case to track something like
this down. At the moment I have no idea what is going on and no
real information on which to even base a guess.

Were there any other messages in the log?

On Mon, Jan 22, 2007 at 10:42:36AM +0100, Stefan Priebe - FH wrote:
> Hi!
> 
> I've another idea... could it be, that it is a barrier problem? Since 
> barriers are enabled by default from 2.6.17 on ...

You could try turning it off. If it does fix the problem, then I'd be
pointing once again at hardware ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
