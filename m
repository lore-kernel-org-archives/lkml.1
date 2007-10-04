Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbXJDXGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbXJDXGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbXJDXGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:06:23 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:53379 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbXJDXGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:06:21 -0400
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 19:06:21 EDT
X-IronPort-AV: E=Sophos;i="4.21,232,1188770400"; 
   d="scan'208";a="154951155"
Date: Thu, 4 Oct 2007 23:56:00 +0100
From: Derek Fawcus <dfawcus@cisco.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access   Control Kernel
Message-ID: <20071004235600.A4177@mrwint.cisco.com>
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org> <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au> <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org> <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil> <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org> <4702B1D5.5050502@tmr.com> <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org> <alpine.LFD.0.999.0710021615520.3579@woody.linux-foundation.org> <20071003011246.7313facb@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Mailer: Mutt 1.0.1i
In-Reply-To: <20071003011246.7313facb@the-village.bc.nu>; from alan@lxorguk.ukuu.org.uk on Wed, Oct 03, 2007 at 01:12:46AM +0100
Authentication-Results: ams-dkim-1; header.From=dfawcus@cisco.com; dkim=pass (
	sig from cisco.com/amsdkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 01:12:46AM +0100, Alan Cox wrote:
> 
> The value of SELinux (or indeed any system compartmentalising access and
> limiting damage) comes into play when you get breakage - eg via a web
> browser exploit.

well,  being sick of the number of times one has to upgrade the browser
for exploits,  I addressed it in a different way.

I ran firefox setuid to a different (not my main user),  uid+gid,  gave
my main account that gid as a supplemental group,  and gave that uid
access to the X magic cookie.

...  which only changes the nature of any exploit that might occur - any
injected code would have to go via X to attack my main account.

DF
