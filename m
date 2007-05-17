Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbXEQOhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbXEQOhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXEQOhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:37:24 -0400
Received: from 125.14.124.24.cm.sunflower.com ([24.124.14.125]:4386 "EHLO
	mail.atipa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754303AbXEQOhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:37:24 -0400
Message-ID: <464C68A0.2050003@atipa.com>
Date: Thu, 17 May 2007 09:37:20 -0500
From: Roger Heflin <rheflin@atipa.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: Re: Apparent Deadlock with nfsd/jfs on 2.6.21.1 under bonnie.
References: <4649BED9.6090207@atipa.com> <pan.2007.05.15.22.03.07.359081@linux.vnet.ibm.com>
In-Reply-To: <pan.2007.05.15.22.03.07.359081@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 May 2007 14:39:56.0937 (UTC) FILETIME=[3D4B3F90:01C79891]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp wrote:

> 
> I don't have an answer to an ext3 deadlock, but this looks like a jfs
> problem that was recently fixed in linux-2.6.22-rc1.  I had intended to
> send it to the stable kernel after it was picked up in mainline, but
> hadn't gotten to it yet.
> 
> The patch is here:
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=05ec9e26be1f668ccba4ca54d9a4966c6208c611
> 

Dave,

That appears to have fixed the JFS hangup.

MTBF before was about 1 hour, under the same test I am over 20 hours
and things appear to still be holding together.

                             Roger
