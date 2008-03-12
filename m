Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYCLTsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYCLTsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYCLTsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:48:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYCLTsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:48:06 -0400
Date: Wed, 12 Mar 2008 15:47:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080312194751.GF13549@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080311211004.GA30164@redhat.com> <1205286326.29069.16.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205286326.29069.16.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 09:45:26AM +0800, Huang, Ying wrote:

[..]
> > I have thought through it again and try to put together some of the
> > new kexec options we can introduce to make the whole thing work. I am 
> > considering a simple case where a user boots the kernel A and then
> > launches kernel B using "kexec --load-preseve-context". Now a user
> > might save the hibernated image or might want to come back to A.
> > 
> > - kexec -l <kernel-image>
> >         Normal kexec functionality. Boot a new kernel, without preserving
> >         existing kernel's context.
> > 
> > - kexec --load-preserve-context <kernel-image>
> >         Boot a new kernel while preserving existing kernel's context.
> > 
> >         Will be used for booting kernel B for the first time.
> > 
> > - kexec --load-resume-image <resumable-core>
> 
> In original kexec-tools, this can be done through:
> kexec -l --args-none <resumable-core>
> 
> Do you need to define an alias for it?

Ok, we can get rid of --load-resume-image and go by the Eric's idea
of detecting image type and taking action accordingly.

Thanks
Vivek
