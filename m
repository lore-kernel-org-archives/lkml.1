Return-Path: <linux-kernel-owner+w=401wt.eu-S1760686AbXEQBJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686AbXEQBJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 21:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXEQBJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 21:09:09 -0400
Received: from alnrmhc12.comcast.net ([206.18.177.52]:48270 "EHLO
	alnrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXEQBJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 21:09:08 -0400
Message-ID: <464BA9FB.9020102@comcast.net>
Date: Wed, 16 May 2007 21:03:55 -0400
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>, davej@redhat.com,
       duaneg@dghda.com, prakash@punnoor.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
References: <20070516235050.9B4237B409F@zog.reactivated.net> <20070517002614.GU15763@ifa.hawaii.edu> <464BA7C2.5040504@gentoo.org>
In-Reply-To: <464BA7C2.5040504@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> Joshua Hoblitt wrote:
>> I don't think this is quiet right either as Ed Sweetman has reported
>> that this issue doesn't occur on single socket/multi-core systems.
>
> Where did he write that? In an off-list mail, Ed seemed to agree with 
> my patch.
>
> Daniel
>
>
What i didn't agree with was the dependency on the acpi P-state driver 
for single socket multi-core systems, where in the original post of this 
thread, Joshua was stating that smp systems required that driver.   
Later it was found that the acpi p-state driver was only being used to 
enforce the dependency on the acpi_processor driver ...which is the 
actual driver we care about (dependency wise).  

So yes, I do agree with your patch, in so far as my experience with the 
hardware.


