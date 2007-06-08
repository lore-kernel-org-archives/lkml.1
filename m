Return-Path: <linux-kernel-owner+w=401wt.eu-S970238AbXFHRvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970238AbXFHRvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969312AbXFHRvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:51:00 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:50742 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967008AbXFHRu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:50:59 -0400
Date: Fri, 8 Jun 2007 13:50:58 -0400
To: Mike Schmidt <mike@intello.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6 kernel: Cannot make multiple dummy network interfaces
Message-ID: <20070608175058.GG10008@csclub.uwaterloo.ca>
References: <46699318.3060209@intello.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46699318.3060209@intello.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 01:34:16PM -0400, Mike Schmidt wrote:
> (please cc me directly with any responses - I am not (yet) a member of 
> this mailing list.
> 
> *2.6 kernel: Cannot make multiple dummy network interfaces*
> ------------------------------------------------------------------------
> I'm trying to set up a number of dummy interfaces but FC6 (Centos4, even 
> RHEL4) won't make more than 1. a modprobe -c lists two default dummy 
> interfaces, dumm0 and dummy1, just as it did even back to rh8. On my 
> rh8/rh9 systems, there is no problem, I can generate as many dummy n as 
> I want by adding alias and options lines in modules.conf. On 
> FC6/Centos/RHEL (I assume as of kernel 2.6, but I don't have any early 
> FC systems running) I can only create 1 dummy. I am trying to build a 
> network simulator for testing purposes - a bridge with 100+ network 
> interfaces. They have to be dummy (not just an alias) because they need 
> separate MAC addresses.  I have tried the same thing on Knoppix, running 
> 2.6.17, with the same results. Centos4 and RHEL4 use kernel 2.6.9

# modinfo dummy
filename:       /lib/modules/2.6.18-4-gx1/kernel/drivers/net/dummy.ko
license:        GPL
vermagic:       2.6.18-4-gx1 preempt mod_unload GEODEGX1 gcc-3.3
depends:
parm:           numdummies:Number of dummy pseudo devices (int)

Perhaps you want to pass that numdummies aregument with some value.  The
default may be pretty low.

--
Len Sorensen
