Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbYEFUEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbYEFUEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758456AbYEFUEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:04:13 -0400
Received: from race2.oit.umass.edu ([128.119.101.38]:42204 "EHLO
	race2.oit.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbYEFUEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:04:12 -0400
X-Greylist: delayed 3595 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 16:04:12 EDT
Message-ID: <4820ABA5.3020705@gmail.com>
Date: Tue, 06 May 2008 15:04:05 -0400
From: Adrian Sud <pigsflew2008@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Parsing Structures postmortem from memory dump
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on a project attempting to extend the volatility toolkit 
(www.volatilesystems.com) to read Linux memory; for now I am attempting 
to support Kernel 2.6.22-14 using i686 arch.

What I mean to do is have it first identify that the image is from a 
linux environment, and then parse out the processes that were running 
when the image was taken.

I've looked at /include/linux/sched.h and tried to understand the 
task_struct structure, but it appears to be variable-length, determined 
at compile time, and I can't tell exactly how these are stored 
throughout memory--In a list? a tree?

If anyone can point me to more information toward finding out how to 
trace this, I would appreciate it.

Thank you,

Adrian Sud

UMass Amherst
Dept. of Computer Science
