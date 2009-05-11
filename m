Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbZEKVG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbZEKVG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZEKVGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:06:20 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:44270 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbZEKVGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:06:19 -0400
MIME-Version: 1.0
In-Reply-To: <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
References: <20090509143742.GA27663@kroah.com> <1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil> 
	<20090511175626.GA4758@kroah.com> <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 23:05:59 +0200
Message-ID: <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 22:41, David P. Quigley <dpquigl@tycho.nsa.gov> wrote:

> This however does highlight a problem with the fact that device node
> labeling isn't being done properly. It should be possible to create this
> fs with a different name such that it doesn't appear as a tmpfs file
> system to SELinux. If it appears as a devtmpfs file system then we can
> specify the root label and labels on the other devices properly in
> policy.

That could be done, if it solves this problem. Damn, now we have the
naming problem back again. :)

By doing its own fstype, we could also make the auto-mount optional,
because you could always reach the filesystem anytime later.

A different fstype has the slight inconvenience, that existing
userspace needs to be taught to handle it explicitly, while a tmfps is
already handled automatically because we use tmpfs already today. But
that may not be too important.

Thanks a lot for your tests and analysis,
Kay
