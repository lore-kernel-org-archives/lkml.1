Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYJGPEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYJGPEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYJGPEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:04:11 -0400
Received: from dsl081-246-077.sfo1.dsl.speakeasy.net ([64.81.246.77]:49831
	"EHLO piratehaven.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751633AbYJGPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:04:10 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2008 11:04:10 EDT
Date: Tue, 7 Oct 2008 07:55:10 -0700
From: Brian Pomerantz <bapper@piratehaven.org>
To: George Nychis <gnychis@cmu.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Randy.Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: how to link to hrtimers in the kernel
Message-ID: <20081007145510.GA31057@skull.piratehaven.org>
References: <48EA31A4.6080903@cmu.edu> <Pine.LNX.4.64.0810060931140.4121@shark.he.net> <alpine.LFD.2.00.0810061849090.3166@apollo> <48EA47DF.2090207@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EA47DF.2090207@cmu.edu>
User-Agent: Mutt/1.4.2.2i
X-homepage: http://www.piratehaven.org/~bapper/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 01:16:15PM -0400, George Nychis wrote:
> 
> I am trying to sleep at the microsecond level, which ssleep and msleep 
> cannot provide.  I couldn't find any other nanosleep method in the kernel.
> 
> I found information by searching the net on using jiffies to accomplish 
> sleep periods, but that is not high enough in resolution.
> 
> I'd greatly appreciate any feedback.
> 

Is there any reason you can't use udelay()/ndelay()?


BAPper
