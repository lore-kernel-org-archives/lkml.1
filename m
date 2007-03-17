Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbXCQEGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbXCQEGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 00:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbXCQEGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 00:06:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:37894 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbXCQEGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 00:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ke6QLrvbUutmCvy2OCeXFMiEyAhRUXv8gsiEuWxBmYNnQ5THAxfsk9nH6HhrHzjKXOihfDDVTOdqd95cOHgSYX+yGhC4k6WTpFQO+HdXycJtzw83Z5t62B/Y6aawTJJUZhsNl0D9ksSNTRxma1g3jvGABoBUMGnd4ohL25hexZg=
Message-ID: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>
Date: Fri, 16 Mar 2007 23:06:52 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: forced umount?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm interested in understanding the state of Linux with regard to
_really_ forcing a filesystem to unmount.

There is a (stale) project at OSDL that has various implementations:
http://developer.osdl.org/dev/fumount/

Its fairly clear that these efforts (e.g. badfs patches) haven't been
given serious consideration for upstream inclusion.  Do others see
value in the ability to _reliably_ force a umount by having Linux
discard all IOs, open files, dirty inode buffers, etc of a "bad"
blockdevice?  The goal is to not impact the availability or integrity
of Linux while doing so.

Is this forced umount work even considered worthwhile by the greater
Linux community?  Is anyone actively working on this?

Mike
