Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbZIDQz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbZIDQz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932751AbZIDQzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:55:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46005 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbZIDQzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:55:55 -0400
Date: Fri, 4 Sep 2009 17:55:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH 2/2] rtc: Add boot_timesource sysfs
	attribute
Message-ID: <20090904165549.GA25802@srcf.ucam.org>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com> <1252081568-6000-2-git-send-email-mjg@redhat.com> <20090904182528.591dbd29@i1501.lan.towertech.it> <20090904163029.GA25239@srcf.ucam.org> <20090904183828.4376236e@i1501.lan.towertech.it> <20090904164127.GB25419@srcf.ucam.org> <20090904185243.53c9b440@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904185243.53c9b440@i1501.lan.towertech.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 06:52:43PM +0200, Alessandro Zummo wrote:

>  that's ok, but nonetheless there's a problem in hwclock
>  if it takes 3 secs to read the time.

The 3-second case is with virtualised access to the cmos, but you're 
right that it does sound excessive. Even so, it seems like a win to be 
able to avoid running code that the kernel's already run

-- 
Matthew Garrett | mjg59@srcf.ucam.org
