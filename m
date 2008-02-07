Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbYBGJI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbYBGJI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYBGJIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:08:43 -0500
Received: from mx1.wp.pl ([212.77.101.5]:36057 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbYBGJIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:08:40 -0500
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: linux-kernel@vger.kernel.org
Subject: Implementing events about block layer errors?
Date: Thu, 7 Feb 2008 10:19:22 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200802071019.22632.stf_xl@wp.pl>
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [URNE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

My boss wants me to add disk errors uevents, to get information on faulty
devices. He told me catching dmesg information using syslog is not reliable
and he would like to get 100% certain information. I know there are currently
implemented uevents in the device mapper layer, but they are limited to
multipath targets. Even if error events were added to the device mapper, 
would it be impossible to find out which physical device generates errors
if the device mapper works on top of the software RAID (correct?). 

Does it make sense to add such a functionality to the block layer 
(or somewhere else), and also could such a modification be included
in the mainline kernel, or  should I rather convince my boss to implement
it via syslog?

Stanislaw Gruszka
