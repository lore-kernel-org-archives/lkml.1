Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbYK2XC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbYK2XC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 18:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYK2XCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 18:02:49 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49074 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYK2XCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 18:02:48 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: xfs@oss.sgi.com
Subject: Re: hangs with MTRR_SANITIZER? - no, something else
Date: Sun, 30 Nov 2008 00:02:45 +0100
User-Agent: KMail/1.9.9
Cc: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <200811252244.14718.Martin@Lichtvoll.de> <200811282339.24197.Martin@lichtvoll.de> <200811290824.38750.Martin@lichtvoll.de> (sfid-20081129_083903_406893_57EEF7DC)
In-Reply-To: <200811290824.38750.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811300002.45669.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 29 November 2008 schrieb Martin Steigerwald:
> Hi!
>
> CC'd to linux-kernel mailinglist, as that might be something that goes
> beyond any possible TuxOnIce or XFS issues. I know I am using TuxOnIce
> which is not part of the mainline kernel. And I am even using an
> inofficial patch - which I will use again unchanged for the non
> MTRR_SANITIZER kernel, in order to know whether its the MTRR_SANITIZER
> thing. And anyway before knowing whether it might be MTRR_SANITIZER
> related I need to run the non MTRR_SANITIZER kernel for at least a week
> and have quite some hibernate cycles. If someone else had issues with
> MTRR_SANITIZER I would like to hear about it. Also if someone thinks I
> am completely off track on trying to track this down I appreciate a
> hint.

Ok, its not MTRR_SANITIZER. It hung again on hibernate, again before any 
serious hibernating work has started. I will add debug output to my 
pre-hibernate script as it might hang already in there, maybe while 
disabling the network. I want to know whether it hangs before calling the 
hibernate script or after it. I think I will go for the latest official 
hibernate patch instead of using the inofficial one, although I am not 
convinced that it makes much of a difference. Lets see.

The syncs I added to my pre-hibernate seemed to help. KDE configuration is 
intact. As a safeguard I rsync ~/.kde to a backup directory before 
hibernating anyway.

Lets see what ideas I have to continue that Sherlock Holmes game ;)

I am puzzled that it only happens on my ThinkPad T42, not on the T23 and 
neither on the Dell workstation - till now.

Goodnight ;-),
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
