Return-Path: <linux-kernel-owner+w=401wt.eu-S1161489AbXDWTbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161489AbXDWTbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161488AbXDWTbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:31:04 -0400
Received: from ctb-mesg-2-2.saix.net ([196.25.240.87]:41032 "EHLO
	ctb-mesg-2-2.saix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161483AbXDWTbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:31:03 -0400
X-Greylist: delayed 2285 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2007 15:31:02 EDT
Message-ID: <462D0085.6070806@telkomsa.net>
Date: Mon, 23 Apr 2007 20:52:53 +0200
From: Niel Lambrechts <unix@telkomsa.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [report] renicing X, cfs-v5 vs sd-0.46
References: <8c1Z0-5Lw-29@gated-at.bofh.it> <8cWMV-8vr-3@gated-at.bofh.it> <8d8uH-1sm-3@gated-at.bofh.it> <8dawR-4zw-21@gated-at.bofh.it>
In-Reply-To: <8dawR-4zw-21@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> This message prompted me to do some checking in re context switches myself, 
> and I've come to the conclusion that there could be a bug in vmstat itself.

Perhaps. perhaps not. :)

> Run singly the context switching is reasonable even for a -19 niceness of x, 
> its only showing about 200 or so on the first loop of vmstat.  But throw in 
> the -n 1 arguments and it goes crazy on the second and subsequent loops.

man vmstat:
"The first report produced gives averages since the last reboot.
Additional reports  give information on a sampling period of length delay."

Regards,
Niel
