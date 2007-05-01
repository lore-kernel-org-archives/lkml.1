Return-Path: <linux-kernel-owner+w=401wt.eu-S1423643AbXEAVWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423643AbXEAVWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423661AbXEAVWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:22:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423643AbXEAVWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:22:06 -0400
Date: Tue, 1 May 2007 17:21:28 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21rc7-mm1 usb/sysfs oops.
Message-ID: <20070501212128.GI2843@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070501182301.GB2843@redhat.com> <20070501135552.ab54be25.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501135552.ab54be25.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 01:55:52PM -0700, Andrew Morton wrote:

 > Unfortunately rc7-mm1 and rc7-mm2 had dodgy-now-dropped sysfs changes in
 > it, so this might be a consequence of that.
 > 
 > > No more being a smart-ass for me today.
 > 
 > Would be good to test mainline instead, and/or -mm when Tejun's new sysfs
 > patches appear.  And cc linux-usb-devel and linux-scsi when it goes boom.

2.6.21 seems to survive.
Though replugging is treated as a new device, so it never reconstructs
the 'array'.   Hmm, udev removed /dev/sdd when I removed the stick,
and on reinsertion created it /dev/sdf.  How helpful of it. Hrmph.

udev sillies aside, it seems to behave as expected.

	Dave

-- 
http://www.codemonkey.org.uk
