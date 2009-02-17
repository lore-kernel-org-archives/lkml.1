Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZBQSmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZBQSmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZBQSll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:41:41 -0500
Received: from kroah.org ([198.145.64.141]:52412 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753013AbZBQSlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:41:40 -0500
Date: Tue, 17 Feb 2009 10:39:54 -0800
From: Greg KH <greg@kroah.com>
To: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: xpad.c - Xbox 360 wireless and sysfs support
Message-ID: <20090217183954.GA22850@kroah.com>
References: <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com> <20090216161331.GB5008@kroah.com> <5aa163d00902161009l15dae120le96436d40f998d33@mail.gmail.com> <20090216185914.GA6239@kroah.com> <5aa163d00902161130r2030adb8h6eb1ec08bda92744@mail.gmail.com> <20090216202215.GA6543@kroah.com> <5aa163d00902161853x27d98a83l3c2c02abe651fe1e@mail.gmail.com> <20090217031813.GD8343@kroah.com> <5aa163d00902162057l106c001bo519a5241c79b5e96@mail.gmail.com> <5aa163d00902171027o139ba751r8103f948f3f492bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aa163d00902171027o139ba751r8103f948f3f492bb@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 01:27:48PM -0500, Mike Murphy wrote:
> On Mon, Feb 16, 2009 at 11:57 PM, Mike Murphy <mamurph@cs.clemson.edu> wrote:
> > Unless that is some common error that is obvious from its description,
> > I will have to chase the bug down tomorrow or Wednesday. It's getting
> > a bit late here.
> >
> 
> Fixed... the function signature was wrong. Should have been:

Ah, always pay attention to complier warnings :)

> static ssize_t xpad_show_dead_zone(struct device *dev, struct
> device_attribute *attr, char *buf)
> 
> Incidentally, both Documentation/driver-model/device.txt and
> Documentation/filesystems/sysfs.txt appear to be wrong. The former
> defines the device attribute structure as:

<snip>

Care to send a patch to fix up the documentation?

thanks,

greg k-h
