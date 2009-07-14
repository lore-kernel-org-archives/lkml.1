Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZGNQZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZGNQZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZGNQZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:25:11 -0400
Received: from ns.ariel-networks.com ([122.216.114.210]:50027 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbZGNQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:25:10 -0400
X-Greylist: delayed 1760 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 12:25:10 EDT
To: linux-kernel@vger.kernel.org
Subject: Question : About the i/o processing to take around common i/o intercafe of submit_bio()
Message-Id: <20090714155549.EAE5D958003@ns.ariel-networks.com>
Date: Wed, 15 Jul 2009 00:55:49 +0900 (JST)
From: ohyama_sec@ariel-networks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroyasu OHYAMA

Sorry, I'm not always contribute but ask you questions. Today, I also want to ask Kernel-Developpers a internal kernel-processing that is about i/o submittion interface.

I'm a Japanese student, now I develop cache system that work under the page-cache layer for my enjoyment.
(Incidentally, The main porpose of this system is to save energy consumption of disk storage)

To implement this system in GNU/Linux, I hooked bio object at submit_bio(). I know that pdflush and other upper layer software, low level file-system, call this routine to operate block i/o. So I think that 'submit_bio' is the interface of i/o submittion and the system that I made seems like to run smoothly.

But I found the Kernel-Document say that

'The normal i/o submission interfaces, e.g submit_bio, could be bypassed
for specially crafted requests which such ioctl or diagnostics
interfaces would typically use, ...' 
[(v2.6.24) block/biodoc.txt l.306]

I investigated ioctl and read sys_ioctl(). But this processing is too complex to find out target processing.
Could you please tell me what kind of request that is second argument of ioctl() system-call cause bypass of submit_bio i/o interface.
And if there are other processing which operate block device without using submit_bio(), I want to know where these processings are.

Thank you in advance.
