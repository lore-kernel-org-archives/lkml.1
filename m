Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYHIW6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYHIW6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYHIW6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:58:13 -0400
Received: from cpsmtpo-eml03.kpnxchange.com ([213.75.38.152]:30991 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbYHIW6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:58:12 -0400
From: Frans Pop <elendil@planet.nl>
To: Greg KH <greg@kroah.com>
Subject: Re: [00/03] [RFC] USB debugging rework
Date: Sun, 10 Aug 2008 00:57:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080809013820.GA10910@kroah.com>
In-reply-To: <20080809013820.GA10910@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808100057.58863.elendil@planet.nl>
X-OriginalArrivalTime: 09 Aug 2008 22:58:10.0737 (UTC) FILETIME=[6546A210:01C8FA73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I've been annoyed for a long time that we make users go off and rebuild
> their kernels just to enable usb debug messages.  So finally, here's the
> start of fixing that issue.

Will your patches also allow to turn off the usb debugging at some point, 
for example after system boot has been completed if the debugging was 
only needed to analyze a boot issue?

I noticed earlier this week that USB debugging will really flood the 
syslog and had to rebuild my -rc2 kernel without debugging and reboot to 
get rid of it. AFAICT with your patches only rebooting would be needed, 
but it would be even nicer if it also could be turned off (and on?) using 
a sysfs parameter.

Cheers,
FJP
