Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbZCBVFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbZCBVFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZCBVFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:05:03 -0500
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:31610 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751972AbZCBVFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:05:01 -0500
X-Yahoo-Newman-Id: 204369.16048.bm@omp411.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6M0JXeHUdKZhNh8GKmmEsGWIim3av80VecLLCUKAuCYGZ2FsWQMvTraqasG2vYV00VSVU4mqS3Ies7jzZxI/aLX26xOM5MsmhMrruaBPie313uBwEM0bDZpenPIAJw043J6lg/B0E5mLFK6gLDt6atsPfB/t5aLgp5whDBxl3JQ=  ;
X-YMail-OSG: vc.SFL4VM1kKwEzgNSFheVoAuqwuctcpm_Qii74_Bn7V1JWSKNnea1pXj29ciEMHER.bAfzj8zOq5Iht1p5ITgU.C_lJnQXcpoI23Cf_k.vis.s2znJqsmY3eRQVPq10g6vGVofj7Y1KyUVIOvjGgv2NB42znDh8gITlIEUCWCol8XomdD2fjc8Z5pWV
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Mon, 2 Mar 2009 13:04:56 -0800
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903011454.22280.david-b@pacbell.net> <1235999772.5330.368.camel@laptop>
In-Reply-To: <1235999772.5330.368.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021304.56881.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Peter Zijlstra wrote:
> IRQF_DISABLED is bonkers,

Hmm, after all the work that's been done to get Linux
to the point where *most* drivers run without IRQs
enabled ... that sentiment surprises me.

And I suspect it would surprise most driver developers.


> we should simply always disable interrupts for 
> interrupt handlers.

That would be why you have refused to fix the bug
in lockdep, whereby it forcibly enables that flag?

I've been wondering for some months now why you've
left that bug unfixed.


