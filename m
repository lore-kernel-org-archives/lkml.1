Return-Path: <linux-kernel-owner+w=401wt.eu-S1422712AbXCBBoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422712AbXCBBoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422710AbXCBBoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:44:06 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:56297 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422712AbXCBBoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:44:04 -0500
Date: Fri, 2 Mar 2007 02:43:41 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Sindre =?iso-8859-1?b?QWFt5XM=?= <aamas@stud.ntnu.no>
cc: linux-kernel@vger.kernel.org
Subject: Re: Correct way for an application to sleep?
In-Reply-To: <20070224215403.ka5imjqjo08cko0c@webmail.ntnu.no>
Message-ID: <Pine.LNX.4.61.0702251411320.8734@yvahk01.tjqt.qr>
References: <20070224215403.ka5imjqjo08cko0c@webmail.ntnu.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 24 2007 21:54, Sindre Aamås wrote:
>
>Without root-privilegies, that leaves general purpose sleep functions  
>like nanosleep afaik. The problem is that the granularity of these  
>seems very unpredictable, and if I am to use a lowest common  
>denominator I'd only be able to sleep like 10 ms pr 16.7 ms on fast  
>systems, and not at all on not so fast systems. So, I'd like to know  
>what the "correct" way to handle this kind of situation is, if any,  
>from a kernel perspective. Is the only sensible thing to do to give a  
>user settable preference, deciding on a compromise default (or one  
>that says "screw you old kernels")?

You could use an adaptive sleeping ('overhead-corrected'), but I do not 
know how well it works with asynchronous events (such as audio output).
Take a look at the usleep_ovcorr() function in
http://ttyrpld.svn.sf.net/viewvc/*checkout*/ttyrpld/trunk/user/replay.c


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
