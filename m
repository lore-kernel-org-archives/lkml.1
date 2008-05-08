Return-Path: <linux-kernel-owner+w=401wt.eu-S1763648AbYEHRMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763648AbYEHRMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYEHRMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:12:05 -0400
Received: from mail.mindmedia.com.sg ([210.193.7.34]:38963 "EHLO
	mail.mindmedia.com.sg" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754212AbYEHRME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:12:04 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 13:12:03 EDT
Message-ID: <482332CD.4010706@singnet.com.sg>
Date: Fri, 09 May 2008 01:05:17 +0800
From: "P.V.Anthony" <pvantony@singnet.com.sg>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to change the FSINFO for nfsd?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently a gentoo linux server is used as a nfs server for some Mac OS
X clients. These Mac OS X clients are doing video editing.

Currently the video are captured directly to the NFS mounts.

Here is the problem. The video files are broken into 2GB files. This
because the video editing software(Final Cut Pro) breaks the files into
2GB sizes. It does not seem that the Mac OS X is not doing the breaking
up of files. It is the video editing software.

Some commercial company found an interesting behaviour. All the Mac OS X
NFS server FSINFO response in which the max file size is set to 'FFFF
FFFF FFFF FFFF' (all '1's).

The link about the above information can be found at this link below.
Read towards the bottom of the link.
http://forums.creativecow.net/thread/8/975362

I really would like to know where to change in the NFS source code so
that the FSINFO response from the server in which the max file size is
set to 'FFFF FFFF FFFF FFFF' (all '1's).

P.V.Anthony


