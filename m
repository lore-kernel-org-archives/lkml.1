Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXCVPPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXCVPPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933131AbXCVPPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:15:06 -0400
Received: from mx12.bbn.com ([128.33.0.81]:37278 "EHLO mx12.bbn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142AbXCVPPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:15:05 -0400
X-Greylist: delayed 1570 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2007 11:15:05 EDT
Message-ID: <46029755.3080107@bbn.com>
Date: Thu, 22 Mar 2007 10:48:53 -0400
From: Dan Halbert <halbert@bbn.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: data corruption with nvidia chipsets and IDE/SATA drives // memory
  hole mapping related bug?!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to mention what might be a new twist on this problem. We are 
seeing the same kind of 4k-block data corruption on multiple Tyan 
dual-Opteron boards (S3870) with a ServerWorks chipset, not Nvidia. I 
wonder if it really an Nvidia-specific issue. The Nvidia boards are a 
lot more popular, so maybe it's just more likely to be seen with Nvidia. 
I added a more detailed comment about this to the kernel bug report: 
http://bugzilla.kernel.org/show_bug.cgi?id=7768#c15.

