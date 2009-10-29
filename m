Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZJ2QTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZJ2QTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZJ2QTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:19:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53858 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbZJ2QTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:19:04 -0400
Date: Thu, 29 Oct 2009 10:19:08 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Tejun Heo <teheo@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] Fix updating of named attribute groups
Message-ID: <20091029161907.GL10555@parisc-linux.org>
References: <20091020054740.GC29158@parisc-linux.org> <20091020054946.GD29158@parisc-linux.org> <4AE9BBC6.3070304@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE9BBC6.3070304@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 04:59:02PM +0100, Tejun Heo wrote:
> Matthew Wilcox wrote:
> > +		if (update) {
> > +			sd = sysfs_get_dirent(kobj->sd, grp->name);
> > +			if (!sd)
> > +				return -ENOENT;
> > +		} else {
> > +			error = sysfs_create_subdir(kobj, grp->name, &sd);
> > +			if (error)
> > +				return error;
> > +			sysfs_get(sd);
> > +		}
> > +	} else {
> > +		sd = sysfs_get(kobj->sd);
> > +	}
> 
> nitpick: the last braces aren't necessary.

But are more aesthetically pleasing.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
