Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbYAUI3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbYAUI3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 03:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757982AbYAUI3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 03:29:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:16575 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbYAUI3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 03:29:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=C36CYKjdUNOhRqCIe9iv+dZtn+Frivtm3lisXTUJr08QtZz5EOr4q+TZaUPNWZGDdksMCFNicTtV4fFXxJOq3TqEIGyQj5dZZuSMXJ/rS8GAGkx6TPK2cvMNhT3jUuTWwjY06RDpTl8ItuFKKrRaoCRIs0mZPDg2vkL0/xZbTos=
Date: Mon, 21 Jan 2008 09:36:09 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080121083608.GA1789@ff.dom.local>
References: <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com> <1200626323.5640.21.camel@lov.site> <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com> <20080118073836.GA1703@ff.dom.local> <a8e1da0801172348q575d6c2fs9f51e3e76d41c62@mail.gmail.com> <20080118082327.GC1703@ff.dom.local> <a8e1da0801180107w2d5a4be2r2b30d57a0d2b85ce@mail.gmail.com> <4791C555.9050205@gmail.com> <20080121013021.GB2832@darkstar.te-china.tietoenator.com> <20080121014335.GA3219@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121014335.GA3219@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 09:43:35AM +0800, Dave Young wrote:
...
> Convert the class semaphore to mutex.
> class_interface_register/unregister use class_device_* functions, so SINGLE_DEPTH_NESTING added for lockdep please in these functions. 

Looks fine to me now, but... I think you forgot again to make it
clear that there were no lockdep warnings observed after this patch.
And it seems there should be used something more complex than usb
mouse or modem to verify this. Then IMHO it would be very nice if
Andrew dares to merge this to -mm...

Regards,
Jarek P.

PS: I miss a lot function names in this patch...
