Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYKCVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYKCVSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYKCVSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:18:08 -0500
Received: from mail.crca.org.au ([67.207.131.56]:44178 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbYKCVSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:18:07 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory
	hotplug
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, pavel@suse.cz
In-Reply-To: <20081103125108.46d0639e.akpm@linux-foundation.org>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
	 <200810291325.01481.rjw@sisk.pl>
	 <20081103125108.46d0639e.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Tue, 04 Nov 2008 08:18:00 +1100
Message-Id: <1225747080.6755.14.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2008-11-03 at 12:51 -0800, Andrew Morton wrote:
> On Wed, 29 Oct 2008 13:25:00 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Wednesday, 29 of October 2008, Pavel Machek wrote:
> > > 
> > > hibernation + memory hotplug was disabled in kconfig because we could
> > > not handle hibernation + sparse mem at some point. It seems to work
> > > now, so I guess we can enable it.
> > 
> > OK, if "it seems to work now" means that it has been tested and confirmed to
> > work, no objection from me.
> 
> yes, that was not a terribly confidence-inspiring commit message.
> 
> 3947be1969a9ce455ec30f60ef51efb10e4323d1 said "For now, disable memory
> hotplug when swsusp is enabled.  There's a lot of churn there right
> now.  We'll fix it up properly once it calms down." which is also
> rather rubbery.  
> 
> Cough up, guys: what was the issue with memory hotplug and swsusp, and
> is it indeed now fixed?

IIRC, at least part of the question was "What if memory is hot unplugged
in the middle of hibernating, or between hibernating and
resuming." (Would apply to cold unplugging too).

Regards,

Nigel

