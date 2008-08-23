Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYHWES1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYHWES1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 00:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYHWESU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 00:18:20 -0400
Received: from main.gmane.org ([80.91.229.2]:48940 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYHWESU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 00:18:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Russ Dill <Russ.Dill@gmail.com>
Subject: Re: ftraced and suspend to ram
Date: Sat, 23 Aug 2008 04:18:08 +0000 (UTC)
Message-ID: <loom.20080823T041606-671@post.gmane.org>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <20080822072343.GA24173@atrey.karlin.mff.cuni.cz> <20080822103533.GA5425@joi> <200808221839.35640.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 70.190.167.62 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.0.1) Gecko/2008071816 Ubuntu/8.10 (intrepid) Firefox/3.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki <rjw <at> sisk.pl> writes:
> 
> This is needed to fix compilation, sorry for the omission.
> 
> Still, did you test ftrace + suspend with the original patch and your fix
> applied and if you did, then what happend?
> 
> Rafael
> 

On my x86_64 laptop, both with and without the patch, the laptop never resumes,
nor does it reboot. Just the power light comes on. I've tried the PM test rtc
thing, but the clock never gets changed. Disabling FTRACE causes suspend/resume
to work.


