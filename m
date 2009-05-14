Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbZENFcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbZENFcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 01:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZENFb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 01:31:59 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:40638 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZENFb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 01:31:58 -0400
Message-ID: <4A0BACCA.5050103@in.ibm.com>
Date: Thu, 14 May 2009 11:01:54 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       David.Woodhouse@intel.com
Subject: Re: Next May 13:[drivers/base/firmware*] Bug while booting on x86
References: <20090513164832.c8a0de7d.sfr@canb.auug.org.au> <4A0AC5E6.2010402@in.ibm.com>
In-Reply-To: <4A0AC5E6.2010402@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Sant wrote:
> Call Trace:
> [<c02f417c>] ? firmware_data_write+0x1cb/0x211
> [<c02f3fb1>] ? firmware_data_write+0x0/0x211
> [<c01e618a>] ? write+0x113/0x14a
Could be because of the following patch which last changed the
code in question.

firmware: speed up request_firmware()
http://patchwork.kernel.org/patch/17531/

I will try reverting this patch and check if that helps.

thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

