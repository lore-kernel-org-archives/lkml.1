Return-Path: <linux-kernel-owner+w=401wt.eu-S1761074AbYHEQck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074AbYHEQck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbYHEQcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:32:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52753 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753816AbYHEQcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:32:31 -0400
Date: Tue, 5 Aug 2008 11:32:30 -0500
From: Russ Anderson <rja@sgi.com>
To: Greg KH <greg@kroah.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number on SGI UV
Message-ID: <20080805163229.GA14870@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080731195753.GB25715@sgi.com> <48934926.2010200@zytor.com> <20080804221951.GA252105@sgi.com> <4897A5FE.9070703@zytor.com> <20080805035450.GA11810@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805035450.GA11810@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 08:54:50PM -0700, Greg KH wrote:
> On Mon, Aug 04, 2008 at 05:59:42PM -0700, H. Peter Anvin wrote:
> > Russ Anderson wrote:
> >>> This really seems more that it should belong in sysfs -- 
> >>> /sys/class/firmware presumably.
> >> /proc/sgi_uv already exists, similar to /proc/sgi_sn on Itanium systems.
> >> Would it be /sys/class/firmware?  Reading Documentation/sysfs-rules.txt
> >> seems to indicate somewhere under /sys/devices, such as 
> >> /sys/devices/system/,
> >> but I may be wrong.
> >
> > /sys/class/firmware is usually where firmware-related things end up, but 
> > gregkh is the authority on sysfs organization.
> 
> /sys/class/firmware has a few users, but perhaps you are thinking of
> /sys/firmware instead?  That's probably the better place for something
> that is not using the firmware class itself.

Hi Greg,

If /sys/firmware is the right place, that is where I will put it.

Are the rules for /sys/firmware documented?  Documentation/sysfs-rules.txt
does not mention /sys/firmware.  It seems to indicate that /sys/class
should only contain symlinks:

  There are currently three places for classification of devices:
  /sys/block, /sys/class and /sys/bus. It is planned that these will
  not contain any device directories themselves, but only flat lists of
  symlinks pointing to the unified /sys/devices tree.

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
