Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676Ab0A3OLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0A3OLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 09:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630Ab0A3OLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 09:11:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab0A3OLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 09:11:19 -0500
Subject: Re: [PATCH 0/3] HID: make raw output callback more flexible
From: Bastien Nocera <hadess@hadess.net>
To: Michael Poole <mdpoole@troilus.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <87iqakifm8.fsf@troilus.org>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	 <1264783166.29532.5302.camel@localhost.localdomain>
	 <87iqakifm8.fsf@troilus.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 30 Jan 2010 14:11:03 +0000
Message-ID: <1264860663.29532.7887.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 19:46 -0500, Michael Poole wrote:
> > [1]: Comments on the patch at
> > http://thread.gmane.org/gmane.linux.bluez.kernel/4279 would be
> > appreciated
> 
> This patch does not work for me.  Before, the first time after each
> boot
> that I tried to connect to an Apple Magic Mouse, it failed with -14
> (EFAULT).  With this patch, it fails with -22 (EINVAL) instead.  The
> -EFAULT *was* due to hidp_parse()'s copy_from_user().  I have not
> looked
> yet to see where the -EINVAL is coming from -- would that help?  (Both
> with and without your patch, the second attempt to connect works.) 

I don't get -EFAULT anymore (it was failing to copy the rd_data from
user-space), but I do get -EINVALs now. I haven't investigated it
though. My guess is that the hid parser fails.

Could you compare the sizes of the data gathered in user-space?

