Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZIJS5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZIJS5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZIJS5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:57:00 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:40387 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbZIJS47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=xJgwbhv15he4RkXBNJmZc8wMCYhSuRHfGjaFLeglW8IOqO45AvXINDyGL9OY+Pm7m0
         L7pFGnsHFE3W3LTzUXqByBlEgaQJWFPM2zR9hGaYcDmVZ5ECqnoYuAQ8e5E1IjKqaofX
         YqxBIQCvTUf8zZhLZtDUpyAXuHtYSYbzzZBy4=
MIME-Version: 1.0
From: David Rees <drees76@gmail.com>
Date: Thu, 10 Sep 2009 11:56:42 -0700
Message-ID: <72dbd3150909101156qa2c4e3dnfef02d509f63330f@mail.gmail.com>
Subject: EXT4-fs error - ext4_mb_generate_buddy
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running ext4 on Fedora 10, kernel 2.6.29.6-93.fc10.x86_64.  Partition
in question is an 8 disk software RAID10 with mostly SATA disks and
one IDE disk.  We've never seen any hardware or filesystem corruption
issues on this machine in the past, though the RAID10 setup is new -
was put into service the same time we migrated the partition from ext3
to ext4 (fresh filesystem created and data copied over).

Earlier today, we saw this message in the logs:

EXT4-fs error (device md0): ext4_mb_generate_buddy: EXT4-fs: group
586: 19635 blocks in bitmap, 19636 in gd

It looks rather ominous and we will be scheduling a reboot to force a
fsck as well as to upgrade to kernel-2.6.29.6-99.fc10.x86_64 (which
doesn't appear to have any ext4 related changes in it).  Looking in
the archives, I'm not quite sure what to make of the message, but it
does seem to indicate that we may have filesystem corruption.  Any
suggestions?

Thanks

-Dave
