Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZCRI1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZCRI1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZCRI1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:27:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:56414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZCRI1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:27:20 -0400
Date: Wed, 18 Mar 2009 09:25:23 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Fix the possibility of insane return value of
	hpet_calibrate() against SMI. (take 2)
Message-ID: <20090318082523.GA11543@suse.cz>
References: <49BFA1D7.8020302@windriver.com> <20090318094346.7BA9.E1E9C6FF@jp.fujitsu.com> <20090318113948.7BAD.E1E9C6FF@jp.fujitsu.com> <49C0A65E.2000101@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C0A65E.2000101@ladisch.de>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 08:44:30AM +0100, Clemens Ladisch wrote:
> Yasunori Goto wrote:
> > hpet_calibrate() has a possibility of miss-calibration due to SMI.
> > If SMI interrupts in the while loop of calibration, then return value
> > will be big. This change calibrates until stabilizing by the return
> > value with a small value.
> > 
> > Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> 
> Acked-by: Clemens Ladisch <clemens@ladisch.de>

Acked-by: Vojtech Pavlik <vojtech@suse.cz>

-- 
Vojtech Pavlik
Director SuSE Labs
