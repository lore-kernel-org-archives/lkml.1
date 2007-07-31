Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbXGaMfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbXGaMfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbXGaMfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:35:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46088 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbXGaMfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:35:32 -0400
Date: Tue, 31 Jul 2007 18:17:51 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Tejun Heo <htejun@gmail.com>
cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu
Subject: Re: [PATCH 2/7] sysfs: Remove first pass at shadow directory
 support
In-Reply-To: <46AF0ECD.9090507@gmail.com>
Message-ID: <alpine.LFD.0.999.0707311815400.26032@enigma.security.iitk.ac.in>
References: <11858769083285-git-send-email-htejun@gmail.com>
 <46AF0ECD.9090507@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Tue, 31 Jul 2007, Tejun Heo wrote:

> Tejun Heo wrote:
> > While shadow directories appear to be a good idea, the current scheme
> > of controlling their creation and destruction outside of sysfs appears
> > to be a locking and maintenance nightmare in the face of sysfs
> > directories dynamically coming and going.  Which can now occur for
> > directories containing network devices when CONFIG_SYSFS_DEPRECATED is
> > not set.
> > 
> > This patch removes everything from the initial shadow directory support
> > that allowed the shadow directory creation to be controlled at a higher
> > level.  So except for a few bits of sysfs_rename_dir everything from
> > commit b592fcfe7f06c15ec11774b5be7ce0de3aa86e73 is now gone.
> 
> "From Eric W. Biederman <ebiederm@xmission.com>" line is missing.  I
> thought git scripts would add that automatically.  Sorry about that.

I couldn't find this patch in the patchset you just posted ...
