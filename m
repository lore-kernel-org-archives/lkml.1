Return-Path: <linux-kernel-owner+w=401wt.eu-S934686AbZKYNG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbZKYNG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934662AbZKYNG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:06:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:39349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934661AbZKYNG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:06:56 -0500
Date: Wed, 25 Nov 2009 05:01:31 -0800
From: Greg KH <gregkh@suse.de>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       paul Mackerras <paulus@samba.org>,
       Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 2/3] sysfs cpu probe/release files
Message-ID: <20091125130131.GA18248@suse.de>
References: <4B0CD70F.6090600@austin.ibm.com> <4B0CD8D5.8050803@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0CD8D5.8050803@austin.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 01:12:21AM -0600, Nathan Fontenot wrote:
> In order to support kernel DLPAR of CPU resources we need to provide an
> interface to add (probe) and remove (release) the resource from the system.
> This patch Creates new generic probe and release sysfs files to facilitate
> cpu probe/release.  The probe/release interface provides for allowing each
> arch to supply their own routines for implementing the backend of adding
> and removing cpus to/from the system.
>
> This also creates the powerpc specific stubs to handle the arch callouts 
> from writes to the sysfs files.

Can you document these new sysfs files with some information in the
Documentation/ABI/ directory please?

thanks,

greg k-h
