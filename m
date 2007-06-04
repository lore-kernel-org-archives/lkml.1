Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbXFDPuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbXFDPuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbXFDPuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:50:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37851 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864AbXFDPuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:50:01 -0400
Message-ID: <466434A1.4040905@austin.ibm.com>
Date: Mon, 04 Jun 2007 10:49:53 -0500
From: jschopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
In-Reply-To: <0a25fd03117c678f17006c5fcefaaed0@pinky>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This version brings a host of changes to cure false positives and
> bugs detected on patches submitted to lkml and -mm.  It also brings
> a number of new tests in response to reviews, of particular note:
> 
>   - catch use of volatile
>   - allow deprecated functions to be listed in feature-removal-schedule.txt
>   - warn about #ifdef's in c files


I think the design philosophy of the style checker should be to err on the side of being 
quiet.  It shouldn't report things that aren't problems.  There are plenty of valid uses 
of #ifdefs in c files.  #ifdefs may be abused often.  If we start bothering every author 
that uses #ifdefs with an annoying note it detracts from the usefulness of our tool.

If we really want to complain about #ifdefs we should add a flag to the script so it isn't 
a default.  -potential or something.  We could put all the "this often is an error" type 
warnings under it.

The rest of the patch looks fine.

-Joel
