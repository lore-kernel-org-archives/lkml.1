Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbXCEWVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbXCEWVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbXCEWVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:21:14 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:38351 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbXCEWVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:21:13 -0500
Date: Mon, 5 Mar 2007 23:16:40 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Eric Lacombe <tuxiko@free.fr>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: Linux 2.6.19.2: maybe a bug inside the r8169 network driver (was Re: Linux 2.6.19.2: Freeze with CIFS mount)
Message-ID: <20070305221640.GA25369@electric-eye.fr.zoreil.com>
References: <OFC7B98576.0C582E30-ON87257274.0014583D-86257274.00153815@us.ibm.com> <20070213203047.GA4158@electric-eye.fr.zoreil.com> <200702141149.53041.tuxiko@free.fr> <200703052219.23439.tuxiko@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703052219.23439.tuxiko@free.fr>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe <tuxiko@free.fr> :
[...]
> Also, if you have some new ideas about the problem or what I could try to 
> trigger it more frequently (I already wake up the NAS as more as I can, but 
> maybe I could write a script to do that), I would be thankful.

You can add more DEBUG options for spinlock and stack usage, disable
preempt and pray for a trace before the crash. If you do not have a
second host to add more traffic (wrt to bandwidth and/or pps), try to
dd your disk and/or your remote storage to /dev/null while watching TV.

You are out of luck if it does not crash more easily.

-- 
Ueimor
