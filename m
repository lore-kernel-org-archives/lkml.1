Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbXKFVea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbXKFVea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbXKFVeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:34:05 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:51455 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbXKFVeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:34:01 -0500
Date: Tue, 6 Nov 2007 13:33:18 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [RFC] kobject and kset core changes and cleanups
Message-ID: <20071106213318.GB13972@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071102235758.GA9803@kroah.com> <20071105231148.4f1bd0b1.akpm@linux-foundation.org> <20071106081413.GA12542@frankl.hpl.hp.com> <20071106211527.GA6126@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106211527.GA6126@suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Tue, Nov 06, 2007 at 01:15:27PM -0800, Greg KH wrote:
> On Tue, Nov 06, 2007 at 12:14:13AM -0800, Stephane Eranian wrote:
> > Andrew, Greg,
> > 
> > On Mon, Nov 05, 2007 at 11:11:48PM -0800, Andrew Morton wrote:
> > > On Fri, 2 Nov 2007 16:57:58 -0700 Greg KH <gregkh@suse.de> wrote:
> > > 
> > > > So, I go on vacation for a week or so and come back to an overflowing
> > > > inbox.  Instead of trying to wade through all of that, I decide to
> > > > finish up the work Kay and I had started on cleaning up the kset core
> > > > code.
> > > 
> > > you killed perfmon.
> > > 
> > > perfmon/perfmon_sysfs.c: In function 'pfm_init_sysfs':
> > > perfmon/perfmon_sysfs.c:411: error: 'kernel_subsys' undeclared (first use in this function)
> > > perfmon/perfmon_sysfs.c:411: error: (Each undeclared identifier is reported only once
> > > perfmon/perfmon_sysfs.c:411: error: for each function it appears in.)
> > > 
> > > I'll drop the perfmon tree and shall soldier on.  
> > 
> > I am sure we can fix this. I just need to get the kset patch from Greg.
> 
> What's the status on when perfmon will be sent to Linus?  I'll be glad
> to send you a patch, I'm updating my tree right now, give me a few
> hours...
> 
Trying to get into -mm first. Obvisouly there is a first problem with
kobject/sysfs. But I am hoping it won't be that difficult to fix especially
with your help ;->

-- 
-Stephane
