Return-Path: <linux-kernel-owner+w=401wt.eu-S1031500AbXDZUpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031500AbXDZUpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031503AbXDZUpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:45:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50176 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031500AbXDZUpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:45:04 -0400
To: Chris Snook <csnook@redhat.com>
cc: Vincent ETIENNE <ve@vetienne.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       bonding-devel@lists.sourceforge.net,
       "Andy Gospodarek" <andy@greyhouse.net>
Subject: Re: [Bonding-devel] [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1 
In-reply-to: <46310B19.8@redhat.com> 
References: <200704262058.33087.ve@vetienne.net> <46310B19.8@redhat.com>
Comments: In-reply-to Chris Snook <csnook@redhat.com>
   message dated "Thu, 26 Apr 2007 16:27:05 -0400."
X-Mailer: MH-E 8.0.3; nmh 1.1-RC4; GNU Emacs 22.0.95
Date: Thu, 26 Apr 2007 13:44:59 -0700
Message-ID: <1791.1177620299@death>
From: Jay Vosburgh <fubar@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> wrote:

>Vincent ETIENNE wrote:
>> Hi,
>>  
>>  Summary :
>> 	Got this trace when one network interface come down or up in a 2
>> 	interfaces bonding.	So far, system seems to survive to this problem
>> 	and works fine.
>
>I'm investigating a similar/possibly identical bug.  Do you experience 
>packet loss or throughput stalls, beyond just the loss of the interface 
>that went down, when this happens?

	This problem looks to be one of the known locking issues with
bonding.

	Andy Gospodarek <andy@greyhouse.net> and I have been working
offline on the locking issues in bonding over the last several weeks.
At the moment, we have a generally stable (but ugly with debug fluff and
other yuckies) patch that seems to resolve at least the majority of the
various issues.  I'm thinking to clean it up for general posting early
next week, and address additional problems from there (since it's
hopefully at least a big step forward).

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
