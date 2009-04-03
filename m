Return-Path: <linux-kernel-owner+w=401wt.eu-S934968AbZDCTFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968AbZDCTFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbZDCTFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:05:07 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:42881 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbZDCTFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:05:06 -0400
X-Greylist: delayed 672 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Apr 2009 15:05:05 EDT
Date: Fri, 3 Apr 2009 13:53:50 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: EXT4-ish "fixes" in UBIFS
Message-ID: <20090403185350.GA866071@hiwaay.net>
References: <cmFiD-8uc-9@gated-at.bofh.it> <cmFss-ft-15@gated-at.bofh.it> <cmFsu-ft-23@gated-at.bofh.it> <cmGRt-2hq-7@gated-at.bofh.it> <cmH1b-2K0-11@gated-at.bofh.it> <cmHkz-3d3-5@gated-at.bofh.it> <cmHkA-3d3-7@gated-at.bofh.it> <cmHND-3Oz-5@gated-at.bofh.it> <cmJPm-7hd-5@gated-at.bofh.it> <cmJZ1-7ul-7@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403063059.GO9870@mit.edu>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Theodore Tso  <tytso@mit.edu> said:
>On Thu, Apr 02, 2009 at 11:15:29PM -0600, Trenton D. Adams wrote:
>> 
>> tdamac ~ # mount -t ext3 -o data=writeback,remount,rw /dev/s/sys /
>> mount: / not mounted already, or bad option
>> 
>> Does it have to be done on initial mount?
>
>Yes, which means you have to use the rootflags boot command-line
>option.

Can't you also set this in the superblock options (e.g. "tune2fs -o
+journal_data_writeback" /dev/sda1)?

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
