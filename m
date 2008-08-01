Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYHAB3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYHAB3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 21:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYHAB3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 21:29:25 -0400
Received: from [116.90.133.99] ([116.90.133.99]:41068 "EHLO mars.unix.geek.nz"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYHAB3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 21:29:25 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2008 21:29:24 EDT
Subject: XFS noikeep remount in 2.6.27-rc1-next-20080730
From: Jasper Bryant-Greene <jasper@amiton.co.nz>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Amiton Ltd
Date: Fri, 01 Aug 2008 13:19:58 +1200
Message-Id: <1217553598.3860.16.camel@luna.unix.geek.nz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I mount a bunch of XFS filesystems with "noikeep,attr2,noatime", and a
couple also with "ro".

Sometimes I want to remount one of the "ro" ones "rw", to make changes.
This doesn't work anymore in 2.6.27-rc1-next-20080730. The last kernel I
tried which it worked in was 2.6.26 release.

luna ~ # mount -o remount,rw /usr
mount: /usr not mounted already, or bad option

luna ~ # dmesg | tail -n 1
[18702.291344] XFS: mount option "noikeep" not supported for remount

Is this intended behaviour?

-jasper

