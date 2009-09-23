Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZIWILG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZIWILG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZIWILF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:11:05 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:34857 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbZIWILE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:11:04 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AB9D82F.3030706@cam.ac.uk>
Date: Wed, 23 Sep 2009 09:11:27 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090803)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] [PATCH 2/2] ACPI: introduce ACPI ALS device driver
References: <1253590777.15763.22.camel@rzhang-dt>	 <4AB8C945.8050309@cam.ac.uk> <1253669192.15763.39.camel@rzhang-dt>
In-Reply-To: <1253669192.15763.39.camel@rzhang-dt>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Are there any plausible race conditions associated with doing the allocation this way?
> 
> well, theoretically, yes.
> simultaneous add calls may happen in hotplug case, but I don't think an
> ACPI ALS device supports hotplug.
That would make that point irrelevant!

Thinking further on this. What happens on a box that for some reason repeatedly inserts and
removes this module?

This is the sort of problem idr's are meant to overcome.  They will cost you a bit
in terms of complexity though.

