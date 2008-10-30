Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbYJ3QKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbYJ3QKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYJ3QJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:09:58 -0400
Received: from mail.bitdefender.com ([91.199.104.2]:39377 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYJ3QJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:09:57 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 12:09:56 EDT
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: linux-kernel@vger.kernel.org
Subject: network weirdness
Date: Thu, 30 Oct 2008 18:03:12 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810301803.12622.mihai.dontu@gmail.com>
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.0.0 on
 mail.bitdefender.com, sigver: 7.21573
X-BitDefender-Spam: No (241)
X-BitDefender-SpamStamp: v1, build 2.7.20.55976, bayes score: 500(0),
 pbayes score: 241(241), neunet score: 500(0), total: 241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sometimes faced with a problem, regarding the network, that I am unable to 
reproduce (too easy). Today for example, when I got to work, I was unable to 
do a remote desktop on one of the machines in the same network as me. I kept 
getting a "recv() : connection reset by peer" message each time I tried to 
connect. I was, however, able to talk to every other machine, local or from 
the Internet, except this one. I could also do to a "ssh -X" on another 
computer and then "rdesktop -g 1024x768 winhost" from there. Nothing 
directly, however. After playing with my network interface for a while and 
rebooting the windows machine, I finally gave up and rebooted mine. The 
problem went away.

Has anyone else came across this before?

$ uname -a
Linux mdontu-dell 2.6.27.2 #1 SMP PREEMPT Sun Oct 19 13:34:08 EEST 2008 x86_64 
Intel(R) Core(TM)2 CPU T5500 @ 1.66GHz GenuineIntel GNU/Linux

Almost forgot: I was able to ping the machine, so I assume it's something 
related to TCP/IP.

-- 
Mihai Donțu
