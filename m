Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbXDIRMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbXDIRMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXDIRMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:12:06 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:61800 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbXDIRME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:12:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17946.29660.368403.553290@smtp.charter.net>
Date: Mon, 9 Apr 2007 13:11:56 -0400
From: "John Stoffel" <john@stoffel.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
In-Reply-To: <200704091137.01336.gene.heskett@gmail.com>
References: <200704091007.58535.gene.heskett@gmail.com>
	<461A5204.1050206@garzik.org>
	<200704091137.01336.gene.heskett@gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Gene" == Gene Heskett <gene.heskett@gmail.com> writes:

Gene> On Monday 09 April 2007, Jeff Garzik wrote:
>> Gene Heskett wrote:
>>> Now the 64k$ question: While running with LVM2 managed disks, is it
>>> possible to run without dm_mod, the device-mapper?  If so, please tell
>>> me how to achieve this.
>> 
>> No; device mapper is the kernel portion of LVM2.
>> 
>> Jeff, who actively avoids LVM on home computers

Gene> Ya shoulda warned me.  :-)

Gene> It should have lots bigger warning labels, in bright red
Gene> self-illuminating signs, than it does.  It in fact seems to work
Gene> well, but it is a major breakage for some common apps, like
Gene> doing backups...

>From the GNU info doc on the tar program:

    Metadata stored in snapshot files include device numbers, which,
    obviously is supposed to be a non-volatile value. However, it turns
    out that NFS devices have undependable values when an automounter gets
    in the picture. This can lead to a great deal of spurious redumping in
    incremental dumps, so it is somewhat useless to compare two NFS
    devices numbers over time. The solution implemented currently is to
    considers all NFS devices as being equal when it comes to comparing
    directories; this is fairly gross, but there does not seem to be a
    better way to go.

This to me, seems to be another borkage of the tar program.  Can you
tell Amanda to use 'dump/restore' instead of tar instead?  Or heck,
just move to Bacula, it's smarter than amanda/tar and it supports
writing to DVDs, etc.  http://www.bacula.org

This tar borkness is pretty annoying, since Amanda (from the docs
page) only keeps indexes in terms of host/filesystem/path/date,
nothing about the major/minor (device) numbers.

It just re-inforces my desire to never use Amanda again.

John
john@stoffel.org
