Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbXD0QGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbXD0QGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbXD0QGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:06:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbXD0QGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:06:06 -0400
Message-ID: <46321F17.2090703@sandeen.net>
Date: Fri, 27 Apr 2007 11:04:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Tejun Heo <htejun@gmail.com>, maneesh@in.ibm.com,
       dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com, oneukum@suse.de,
       rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] sysfs: fix i_ino handling in sysfs
References: <11760923274128-git-send-email-htejun@gmail.com> <463216EA.20203@sandeen.net> <20070427153245.GA10999@suse.de>
In-Reply-To: <20070427153245.GA10999@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Apr 27, 2007 at 10:29:46AM -0500, Eric Sandeen wrote:
>>  what about 32-bit stats from 32-bit apps on 64-bit systems?  This will make 
>>  64-bit inode numbers commonplace in sysfs; will this cause problems?  it 
>>  seems that if they get truncated to 32 bits the possibility of duplicate 
>>  inode nrs will come back...
> 
> Yes, this turned out to be a problem as the ppc people found out :)
> 
> Tejun had some follow-on patches fixing this issue up.

Oops, missed that.  I'll go looking, thanks.

-Eric
