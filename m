Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbZD2XzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbZD2XzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 19:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZD2Xy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 19:54:59 -0400
Received: from mail.tpi.com ([70.99.223.143]:3750 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZD2Xy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 19:54:59 -0400
Message-ID: <49F8E8D1.8000202@tpi.com>
Date: Wed, 29 Apr 2009 17:54:57 -0600
From: Tim Gardner <timg@tpi.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT]: staging - mac80211 - unify config_interface and	bss_info_changed
References: <20090429193821.305DAF88CE@sepang.rtg.net> <20090429201947.GB20814@kroah.com> <49F8C120.6080807@tpi.com> <20090429212146.GA5274@kroah.com>
In-Reply-To: <20090429212146.GA5274@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Apr 29, 2009 at 03:05:36PM -0600, Tim Gardner wrote:
>> Greg KH wrote:
>>> On Wed, Apr 29, 2009 at 01:38:21PM -0600, Tim Gardner wrote:
>>>> Greg,
>>>>
>>>> I did a build test to make sure things at least compile. checkpatch is fine
>>>> with these patches, but the drivers clearly have other formatting issues.
>>>>
>>>> Lemme know if you have any problems.
>>> Only thing that is a problem is that I can't pull 3 individual patches
>>> out of one email :)
>>>
>>> Care to use git send-email to send them to me?
>>>
>> Done, though I didn't Cc LKML again. I take it this is your preferred
>> method for receiving patches? I thought you were a git weenie.
> 
> From the MAINTAINERS file:
> 	STAGING SUBSYSTEM
> 	P:	Greg Kroah-Hartman
> 	M:	gregkh@suse.de
> 	L:	linux-kernel@vger.kernel.org
> 	T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> 	S:	Maintained
> 
> I use quilt to handle the large patch queues.
> 
> I also didn't see a 'pull' request in your email, did I miss it?
> 
> And yes, emails are best.
> 
> thanks,
> 
> greg k-h
> 

It was in the original email:

The following changes since commit 789a03102c542f34ae831a3aa8af37c6538449e3:
   Stephen Rothwell (1):
         Add linux-next specific files for 20090429

are available in the git repository at:

   git://kernel.ubuntu.com/rtg/linux-next staging-for-gregkh

Tim Gardner (3):
       staging: winbond: mac80211 - unify config_interface and 
bss_info_changed
       staging: agnx: mac80211 - unify config_interface and bss_info_changed
       staging: stlc45xx: mac80211 - unify config_interface and 
bss_info_changed

  drivers/staging/agnx/pci.c          |   17 +++++++++--------
  drivers/staging/stlc45xx/stlc45xx.c |   28 +++++++++-------------------
  drivers/staging/winbond/wbusb.c     |    9 ---------
  3 files changed, 18 insertions(+), 36 deletions(-)

Why do you want a pull request if you're using quilt?

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
