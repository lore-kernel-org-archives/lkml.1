Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbXEAWgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbXEAWgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbXEAWgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:36:15 -0400
Received: from smtprelay06.ispgateway.de ([80.67.18.44]:47562 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbXEAWgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:36:14 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
Date: Wed, 2 May 2007 00:36:36 +0200
User-Agent: KMail/1.9.6
Cc: "Greg KH" <greg@kroah.com>, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Thomas Hellstr?m" <thomas@tungstengraphics.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric Anholt" <eric@anholt.net>
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com> <20070427163951.GA12216@kroah.com> <21d7e9970704301610u5d5132uc282ac697c9df2be@mail.gmail.com>
In-Reply-To: <21d7e9970704301610u5d5132uc282ac697c9df2be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705020036.38322.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2007, Dave Airlie wrote:
> >   - what's with the /proc interface?  Don't add new proc code for
> >     non-process related things.  This should all go into sysfs
> >     somewhere.  And yes, I know /proc/dri/ is there today, but don't add
> >     new stuff please.
> 
> Well we should move all that stuff to sysfs, but we have all the
> infrastructure for publishing this stuff under /proc/dri and adding
> new files doesn't take a major amount, as much as I appreciate sysfs,
> it isn't suitable for this sort of information dump, the whole one
> value per file is quite useless to provide this sort of information
> which is uni-directional for users to send to us for debugging without
> have to install some special tool to join all the values into one
> place.. and I don't think drmfs is the answer either... or maybe it
> is....

Ok, what about debugfs then? If it is just for debugging blobs -> debugfs,
if it is crucial for operation -> sysfs and representation of one value 
per file.


Regards

Ingo Oeser
