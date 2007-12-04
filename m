Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbXLDIWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbXLDIWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXLDIWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:22:14 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:51200 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbXLDIWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:22:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OFGTF8/HlgiTeTdKz8PYqqizc2FDuoa2BogNr7Zc+88FaW7O1XPPKisqkYGv8IeYboiCob8Xevqj3BHtJpyfLWRkcs6l20hanGGtUKjdPcVMpzClzBZawqZcnvUHk7o+gZfT6RwK9baz0t/dRlyq7NWgl7BJwLCcJ8MwOVjR8YY=
Message-ID: <a8e1da0712040022x6403ced5n62ff1a7a2d219e7c@mail.gmail.com>
Date: Tue, 4 Dec 2007 16:22:13 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: The use of KOBJ_NAME_LEN
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071204082027.GA3014@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204064547.GA17094@darkstar.lan>
	 <20071204074612.GA25316@suse.de>
	 <a8e1da0712032353m1a705ec6ged4d503818ad8f58@mail.gmail.com>
	 <20071204082027.GA3014@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 4:20 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Dec 04, 2007 at 03:53:15PM +0800, Dave Young wrote:
> > On Dec 4, 2007 3:46 PM, Greg KH <gregkh@suse.de> wrote:
> > > On Tue, Dec 04, 2007 at 02:45:47PM +0800, Dave Young wrote:
> > > > Hi,
> > > > Does the KOBJ_NAME_LEN really means the limit of kobject name length? seems
> > > > not . And if it's true, is the KOBJ_NAME_LEN of 20 enough to use?
> > >
> > > No, not anymore, the kobject name is totally dynamic.
> >
> > Eh, Why does this macro still exist? If KOBJ_NAME_LEN is really
> > needed, maybe it should be renamed to something else to avoid
> > misleading.
>
> Right now other .h files use it also.  It isn't hurting anything for
> now, and Kay has some patches he is working on to get rid of the static
> bus_id array, which will then let us get rid of that define entirely.
>

Good to know, thanks!

> thanks,
>
> greg k-h
>
