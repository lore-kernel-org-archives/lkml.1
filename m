Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZHYOHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZHYOHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZHYOG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:06:59 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:65437 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbZHYOG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:06:59 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 10:06:59 EDT
Date: Tue, 25 Aug 2009 08:57:00 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Message-ID: <20090825135700.GA1552296@hiwaay.net>
References: <ciPTu-7f2-47@gated-at.bofh.it> <clrhX-3R1-13@gated-at.bofh.it> <dcEc1-33Z-17@gated-at.bofh.it> <dcFUz-4yN-9@gated-at.bofh.it> <dcHtf-5XC-17@gated-at.bofh.it> <dcNSc-2DU-11@gated-at.bofh.it> <dcOl9-3aC-19@gated-at.bofh.it> <dcOOd-3qM-33@gated-at.bofh.it> <dcOXN-3M5-15@gated-at.bofh.it> <dcPhb-3W6-3@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824223915.GI17684@mit.edu>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Theodore Tso  <tytso@mit.edu> said:
>I'll note, BTW, that AIX uses a journal to protect against these sorts
>of problems with software raid; this also means that with AIX, you
>also don't have to rebuild a RAID 1 device after an unclean shutdown,
>like you have do with Linux MD.  This was on the EVMS's team
>development list to implement for Linux, but it got canned after LVM
>won out, lo those many years ago.

See mdadm(8) and look for "--bitmap".  It has a few issues (can't
reshape an array with a bitmap for example; you have to remove the
bitmap, reshape, and re-add the bitmap), but it is available.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
