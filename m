Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbXLLOjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbXLLOjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbXLLOjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:39:24 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:26982 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbXLLOjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:39:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=F1yRFlkSPzLckE6JhBP02P8fPWRCn6l6jUAmNjAxrHfVGhYXk5rxPW0aOtxXCVReYWlVLW3onNS8Xw+8xYGEeMihDiMqTWj6ur7y2fxSF8naD35NPAcgME8x8DfLzoFb52/xyOStr/vZklfek6qrYuUdFMh+t7I5o1IKVmUaGZo=
Message-ID: <9e0cf0bf0712120639r7bd5582bg63f8512164836989@mail.gmail.com>
Date: Wed, 12 Dec 2007 16:39:18 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: ldm@flatcap.org, ntfs-3g-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ntfs-dev@lists.sourceforge.net
Subject: ldminfo compilation
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I need to compile the ldminfo utility of linux-ntfs's package
linux-ldm. I need this as static or uclibc based.

The author stated in the Documentation/filesystems/ntfs.txt:
"""You will find the precompiled (i386) ldminfo utility there.  NOTE:
You will not be able to compile this yourself easily so use the binary
version!"""

I don't like to use binary versions, but this is not so important....
I cannot use this dynamic linked x86 anyway.

Looking at the sources, it seems that the linux headers used in order
to build this are out of date...

Has anyone succeeded in compiling this? Are there alternatives? I need
to extract the information from ldm partition in order to dmsetup it
correctly.

I've contacted the author, Richard Russon <ldm@flatcap.org> but got no response.

Best Regards,
Alon Bar-Lev.
