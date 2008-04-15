Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbYDOHJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbYDOHJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYDOHIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:08:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:49660 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbYDOHIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VztlMTnvU/pMfNZiAhg5+K88oDaotcIII9FHcY+ppW/EGpsbT8qNoDcy3L/krPv9CYhhFZ1FMYo0k5oG901ftorKew1WGWQKRWrfDyweD0j5v+SH/WuxKJnln0VV9HxeKz6GDuMolI9kHJN6maRMuGJNaYdyu6o7VHgF4OJ/U/g=
Message-ID: <ed10ee420804150008q27eaf88au27abf66e6731bbf7@mail.gmail.com>
Date: Tue, 15 Apr 2008 00:08:39 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH] sysfs: add /sys/dev/{char, block} to lookup sysfs path by major:minor
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       neilb@suse.de, htejun@gmail.com, hpa@zytor.com, lkml@rtr.ca
In-Reply-To: <e9c3a7c20804142146h73095148o15cc75d57079ff55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080414165036.13697.6532.stgit@dwillia2-linux.ch.intel.com>
	 <ed10ee420804142013ld540b76g200b459f13b34d@mail.gmail.com>
	 <e9c3a7c20804142146h73095148o15cc75d57079ff55@mail.gmail.com>
X-Google-Sender-Auth: fbb40412b7430e9a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/08, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Apr 14, 2008 at 8:13 PM, SL Baur <steve@xemacs.org> wrote:
>  > On 4/14/08, Dan Williams <dan.j.williams@intel.com> wrote:

> Thanks for looking it over.  To be honest I was iffy about those
>  buffer sizes as well, and looking closer they are overkill.  Although,
>  they are smaller than the 32-byte buffer in bsg.c :-). 13-bytes is all
>  that is needed given a 12-bit major and 20-bit minor.  Care to send a
>  patch to fix up format_dev_t and print_dev_t?

O.K.  I'll look into it.  The call paths into format_dev_t are clear,
the ones into print_dev_t look a bit more global.

-sb
