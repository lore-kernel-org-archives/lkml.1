Return-Path: <linux-kernel-owner+w=401wt.eu-S1761461AbXGLXLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461AbXGLXLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbXGLXLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:11:00 -0400
Received: from omr3.networksolutionsemail.com ([205.178.146.53]:47342 "EHLO
	omr3.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756800AbXGLXK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:10:59 -0400
From: James <LinuxKernel@jamesplace.net>
Reply-To: LinuxKernel@jamesplace.net
To: Neil Brown <neilb@suse.de>
Subject: Re: Problem recovering a failed RIAD5 array with 4-drives.
Date: Thu, 12 Jul 2007 18:10:57 -0500
User-Agent: KMail/1.9.5
References: <200707120849.16068.LinuxKernel@jamesplace.net> <18070.44975.347933.29688@notabene.brown>
In-Reply-To: <18070.44975.347933.29688@notabene.brown>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121810.57648.LinuxKernel@jamesplace.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu July 12 2007 5:48 pm, you wrote:
> On Thursday July 12, LinuxKernel@jamesplace.net wrote:
> > 
> > []# 
> > 
mdadm --create --verbose /dev/md0 --assume-clean --level=raid5 --raid-devices=4 --spare-devices=0  /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
> > 
> snip
> > 
> >     Number   Major   Minor   RaidDevice State
> >        0       8       17        0      active sync   /dev/sdb1
> >        1       8       33        1      active sync   /dev/sdc1
> >        2       8        1        2      active sync   /dev/sda1
> >        3       8       49        3      active sync   /dev/sdd1
> 
> Something looks very wrong here.  You listed the devices to --create
> in one order:
>    a b c d
> but that appear in the array in a different order
>    b c a d
> 
> Did you cut/paste the command line into the mail, or did you retype
> it?  If you retyped it, could you have got it wrong?
> 
> You need the order that --detail shows to match the order of the
> original array....
> 
> NeilBrown
> 
> 

I don't know the original order of the array before all the problems started. 

Is there a way to determine the original order? 

The order that --detail is showing now is the order that appeared after 
issuing the command is it is in the email. (ie: a b c d)

Thank again.

