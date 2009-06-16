Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZFPAxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZFPAxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 20:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZFPAxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 20:53:30 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:29060 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZFPAx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 20:53:29 -0400
Date: Mon, 15 Jun 2009 20:53:19 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Btrfs rescue images
Message-ID: <20090616005319.GA3735@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A36ED01.00EB:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

As Linus discovered, the new btrfs disk format in 2.6.31-git can be
problematic if your FS gets forward rolled to the new format and you end
up bisecting back to the old code.

It would also be nice to have a way to run btrfsck on a root filesystem
and do other assorted tasks.  So, I'm making live boot usb images for
both x86 and x86-64.

They should have enough to get your filesystems mounted and they also
include git, gcc, make and enough to compile the kernel.  These are
based on the Arch 2.6.30 distro with just the btrfs newformat code
added.

I've got the 32 bit image uploaded, and I'll queue up 64 bit overnight.
If anyone is feeling brave, just dd the image onto a usb stick and
rescue boot away.

They work on both of my test boxes, but a little extra testing would be
nice.

-chris

