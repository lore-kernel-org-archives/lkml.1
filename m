Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYDRAnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYDRAnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 20:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbYDRAnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 20:43:08 -0400
Received: from mail.cyberdogtech.com ([64.22.125.39]:38919 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbYDRAnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 20:43:07 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2008 20:43:07 EDT
Date: Thu, 17 Apr 2008 19:33:50 -0500
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Subject: ipsec blocking issue in 2.6.25 (and earlier)
Message-Id: <20080417193350.8e615006.kernel1@cyberdogtech.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to call attention to an apparent bug that has been causing me some significant trouble lately.  In brief, transmission of data over IPSEC (apparently the sendmsg call in particular) is blocking when the IPSEC connection becomes unavailable.  This is causing various daemons such as named and squid to behave rather badly... in the case of named, it binds (no pun intended) up the entire daemon and it starts refusing queries from all interfaces.

I first noticed this somewhat earlier on in the 2.6.2x series, but only recently did I find a fairly comprehensive bug report with Redhat that confirmed the issue.  Please see the full report here:
https://bugzilla.redhat.com/show_bug.cgi?id=427629

Please also note that I'm actually experiencing this under Ubuntu, and am using a custom built (fairly minimal; unpatched) kernel.  This apparently confirms that it is not a distro-specific issue, and is most likely a fairly purvasive kernel bug.

As I can still replicate this fairly readily, I'd be glad to assist in further troubleshooting, but I'm about at the end of my range when it comes to diagnosing the issue myself.

Thanks,
Matt LaPlante
