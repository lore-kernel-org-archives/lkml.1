Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbXIZFOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbXIZFOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 01:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbXIZFOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 01:14:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:28894 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbXIZFOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 01:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=k4dG8uvvLMtf6QTJfSCGpssbvr4BAa99j/mQTpKI3xXX0aU4POCMlblLVgDgo1wUFwxhH6SasCtimE4BDsrHcSWDRPMZVMOeVDUOZtaF8HJJX2OqP8vg8dBtqTuv7O2AvqOwSjJVm90Zs9CEW1wtsNg9NxG0DPbDD8noUE70wo8=
Date: Wed, 26 Sep 2007 13:14:12 +0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: venkatesh.pallipadi@intel.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm1: somewhat broken forced HPET on ICH5
Message-ID: <20070926091412.GA1752@martell.zuzino.mipt.ru>
References: <20070925205006.GA1766@martell.zuzino.mipt.ru> <1190756717.17409.80.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190756717.17409.80.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 11:45:17PM +0200, Thomas Gleixner wrote:
> On Wed, 2007-09-26 at 00:50 +0400, Alexey Dobriyan wrote:
> > ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
> > is causing the following on Etch boot:
> > 
> > 	[initscripts as usual]
> > 	Setting system clock:
> > 	[nothing happens for several seconds]
> > 	select to /dev/rtc to wait for clock tick timed out
> > 	[initscripts as usual]
> > 
> > Then clock is skewed for 3 hours (GMT/MSK difference).
> 
> Can you please check, whether 
> 
> http://tglx.de/projects/hrtimers/2.6.23-rc7/patch-2.6.23-rc7-hrt1.patch
> 
> has the same problem ? It contains the hpet force enable patches as
> well, but lacks the other crap^Wfeatures of -mm :)

Yes, exactly same delay and clock skew.
