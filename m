Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYBRSVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYBRSVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYBRSVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:21:44 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57085 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbYBRSVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:21:43 -0500
Message-ID: <47B9CCB5.7080703@lwfinger.net>
Date: Mon, 18 Feb 2008 11:21:41 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: keyboard dead with 45b5035 - Regression in 2.6.25-rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The patch "[RTNETLINK]: Send a single notification on device state changes." kills (at least) the 
 > keyboard here. Everything seems to work fine in single user mode, but when init starts spawning 
of > logins, the keyboard goes bye-bye. Even the power button is ignored. :/
 >
 > I've tried just creating another vt with "chvt 2", but that is insufficient to trigger the bug.

I can confirm this problem. On my system it is not triggered by logins as my system boots into KDE, 
but as soon as NetworkManager starts and/or makes a connection, the problem is triggered. The 
wireless system is being used. I found the problem by bisection and confirmed that 
v2.6.25-rc2-238-gb45e229 will work OK if that commit is reverted.

Larry


