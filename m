Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbXLDISb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbXLDISb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXLDISY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:18:24 -0500
Received: from mx1.suse.de ([195.135.220.2]:45573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbXLDISX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:18:23 -0500
Date: Tue, 4 Dec 2007 00:20:27 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The use of KOBJ_NAME_LEN
Message-ID: <20071204082027.GA3014@suse.de>
References: <20071204064547.GA17094@darkstar.lan> <20071204074612.GA25316@suse.de> <a8e1da0712032353m1a705ec6ged4d503818ad8f58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0712032353m1a705ec6ged4d503818ad8f58@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 03:53:15PM +0800, Dave Young wrote:
> On Dec 4, 2007 3:46 PM, Greg KH <gregkh@suse.de> wrote:
> > On Tue, Dec 04, 2007 at 02:45:47PM +0800, Dave Young wrote:
> > > Hi,
> > > Does the KOBJ_NAME_LEN really means the limit of kobject name length? seems
> > > not . And if it's true, is the KOBJ_NAME_LEN of 20 enough to use?
> >
> > No, not anymore, the kobject name is totally dynamic.
> 
> Eh, Why does this macro still exist? If KOBJ_NAME_LEN is really
> needed, maybe it should be renamed to something else to avoid
> misleading.

Right now other .h files use it also.  It isn't hurting anything for
now, and Kay has some patches he is working on to get rid of the static
bus_id array, which will then let us get rid of that define entirely.

thanks,

greg k-h
