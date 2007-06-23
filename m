Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbXFWQbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbXFWQbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbXFWQbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:31:23 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:37726 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753899AbXFWQbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:31:23 -0400
Message-ID: <467D4AD3.1010205@lwfinger.net>
Date: Sat, 23 Jun 2007 11:31:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
Newsgroups: opensuse.org.suse-linux.support.install-configure-administration
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: WiFi(wlan): reporting not real signal (always at 100%)
References: <3rGdi.4012$%54.2782@prv-forum2.provo.novell.com>
In-Reply-To: <3rGdi.4012$%54.2782@prv-forum2.provo.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Callejas wrote:
> Hi,
> 
> My system is:
> 
> openSUSE 10.2
> kernel: 2.6.22-rc3-git2-47
> Atheros wireles card
> MadWifi version: svn r2484 (the last at jun/18/07)
> 
> Problem:
> 
> In NetworkManager applet (KDE (knetworkmanager) and also GNOME NetMgr
> applet) the intensity signal graphic is always at 100% , and also if I
> click on the applet to display the list of availables AP's and their
> respective signal all of them show 100%.
> 
> I also have the default kernel of openSUSE (2.6.18) with madwifi 9.3.1, when
> booting with this kernel the problem does not exist.
> 
> I think the problem could be in the respective kernel module that manage
> wifi, or madwifi are passing bad arguments to this module.

There are two things to check. The first is to do a 'cat /proc/net/wireless' and check the number 
under the word link. The second is to do a 'iwlist scan' command and qheck the "Quality" value. If 
these are both 100%, then it is a problem with the Atheros driver and should be reported as a 
regression to the MadWifi mailing list and/or developers. The rest of the 2.6.22-rc3 kernel is 
functioning correctly.

Larry
