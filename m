Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZBPXNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZBPXNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZBPXNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:13:42 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59974 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZBPXNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:13:42 -0500
Date: Mon, 16 Feb 2009 23:13:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216231324.GA15435@srcf.ucam.org>
References: <200902160010.16955.rjw@sisk.pl> <20090216225831.GH1370@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216225831.GH1370@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 11:58:31PM +0100, Pavel Machek wrote:

> If no devices are being used, and next wakeup is far enough in the
> future, just put system to sleep. Long enough == so far away that
> suspend/wakeup is short compared to that... like 20 seconds on PC.

This is intrinsically difficult with PCs, since we have such a poorly 
defined set of wakeup events. We can't wakeup on generic network 
traffic, just WoL. Many machines won't wake up on keyboard events. 
Meanwhile, on embedded it's becoming a less interesting problem because 
idle and suspended are often now equivalent states. Concentrating on 
runtime PM of as much hardware as possible is arguably more interesting 
for the majority of use cases.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
