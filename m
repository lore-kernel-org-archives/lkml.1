Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbXAWByR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbXAWByR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932612AbXAWByR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:54:17 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:55311 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597AbXAWByR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:54:17 -0500
Date: Tue, 23 Jan 2007 02:54:09 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Peek at envinroment of procs
Message-ID: <Pine.LNX.4.61.0701230247030.317@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


what is the preferred way to get at another process's environment 
variables? /proc/$$/environ looks like the most portable way [across all 
arches Linux runs on], but it cannot easily be mmap'ed because the size 
is not known. In fact, mmap does not seem to work at all on that file. 
So I would have to allocate a large buffer (4K is the limit for procfs 
files AFAICR) to potentially hold big environments, which does not sound 
really wise either. Or is it the best choice available?


	-`J'
-- 
