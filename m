Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYGIUDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYGIUDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYGIUDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:03:30 -0400
Received: from elrond2.infotech.no ([82.134.31.41]:48907 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYGIUD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:03:29 -0400
Message-ID: <4875197E.10009@torque.net>
Date: Wed, 09 Jul 2008 16:03:10 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       taggart@debian.org
Subject: [ANNOUNCE] lsscsi-0.20 released
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about SCSI devices and SCSI hosts. Both a
compact format (default) which is one line per device and a
"classic" format (like the output of 'cat /proc/scsi/scsi') are
supported.

Version 0.20 is available at
http://www.torque.net/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for tarballs, rpm and deb packages.
This is a maintenance release: sysfs strikes again ...

ChangeLog:
Version 0.20 2008/7/9 [svn: r43]
   - Handle SCSI midlayer rework circa lk 2.6.25/26
     - this fix needed if CONFIG_SYSFS_DEPRECATED_V2 is not
       defined in the kernel build (lk 2.6.26)
   - clean superfluous files from package

Doug Gilbert
