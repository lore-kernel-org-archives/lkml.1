Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZKZX2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZKZX2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 18:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZKZX2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 18:28:11 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:35349 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZKZX2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 18:28:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vXR1BNUOO/jaAxUlyVCtUdhmrzpootNAxGRkWL0qGyUUq1AlOpkz2UcBF2Lor3fiQr
         GdGwZ1FBO5rRpqxkN7xKda08qZcYvTMiv+XYkGTPlZEVTkjb9teYl3RkGMwc+Aw27xrb
         zmSw8ZU9Y0qRhJBvHkTIuwUREY85em8AJCxSw=
Date: Thu, 26 Nov 2009 15:28:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jarod Wilson <jarod@wilsonet.com>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ?
Message-ID: <20091126232809.GE6936@core.coreip.homeip.net>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain> <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com> <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com> <E88E119C-BB86-4F01-8C2C-E514AC6BA5E2@wilsonet.com> <m3skc249ev.fsf@intrepid.localdomain> <20091126055302.GI23244@core.coreip.homeip.net> <m37htduo3i.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m37htduo3i.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 07:40:01PM +0100, Krzysztof Halasa wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> 
> > Why would sysfs write be slower than ioctl?
> 
> Sysfs is generally one-value, one-file. open, read/write, close.
> ioctl() OTOH does everything (e.g. a whole key table) in one syscall.

There are binary sysfs attributes. For ioctl you also need to open and
close the device. Plus, how often do you expect to perform this
operation? Don't you think you are trying to optimize something that
does not have any real performavnce impact here?
 
-- 
Dmitry
