Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbZFHE0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbZFHE0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 00:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbZFHE02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 00:26:28 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54833 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZFHE01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 00:26:27 -0400
Message-ID: <4A2C92EB.5020002@in.ibm.com>
Date: Mon, 08 Jun 2009 09:56:19 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [Bug #13473] Bug while trying to launch a KVM guest
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.V6F.5Y7KKB@chimera>
In-Reply-To: <D9VoutSOyXP.A.V6F.5Y7KKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13473
> Subject		: Bug while trying to launch a KVM guest
> Submitter	: Sachin Sant <sachinp@in.ibm.com>
> Date		: 2009-06-05 17:20 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=124422173129047&w=4
> Handled-By	: Mimi Zohar <zohar@us.ibm.com>
>   
This problem is fixed by the following patches.

f06dd16a03f6f7f72fab4db03be36e28c28c6fd6 : IMA: Handle dentry_open failures
1a62e958fa4aaeeb752311b4f5e16b2a86737b23 : IMA: open all files O_LARGEFILE

I can't really say this is a regression. I never had compiled a kernel with
CONFIG_IMA until 2.6.30-rc8. 


Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

