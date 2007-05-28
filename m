Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbXE1VhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbXE1VhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXE1Vg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:36:56 -0400
Received: from mail.tmr.com ([64.65.253.246]:32797 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbXE1Vgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:36:55 -0400
Message-ID: <465B4B75.2040602@tmr.com>
Date: Mon, 28 May 2007 17:36:53 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: What causes iowait other than waiting for i/o?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I recently noted that my system was spending a lot of time in i/o wait 
when doing some tasks which I thought didn't involve i/o, as noted by 
the lack of disk light activity most of the time. I thought of network, 
certainly the NIC had no activity for this job. So I set up a little 
loop to capture all disk i/o and network activity (including loopback). 
That was no obvious help, and the program doesn't use pipes.

At this point I'm really curious, does someone have a good clue?

Note: I don't think this is a bug or performance issue, unless the 
kernel is doing something and charging time to iowait instead of system 
I don't see anything to fix, but I would like to understand.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

