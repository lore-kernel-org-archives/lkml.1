Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753329AbYLRBGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYLRBGV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 20:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYLRBGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 20:06:09 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:42931 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769AbYLRBGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:06:08 -0500
Date: Wed, 17 Dec 2008 19:08:41 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Sharyathi Nagesh <sharyath@in.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        balbir <balbir@linux.vnet.ibm.com>,
        "Rishikesh K. Rajak" <risrajak@in.ibm.com>, akpm@linux-foundation.org
Subject: Re: Error with cgroups: "unused subsystem ns"
Message-ID: <20081218010841.GA17385@hallyn.com>
References: <4948D3C4.9060900@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4948D3C4.9060900@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sharyathi Nagesh (sharyath@in.ibm.com):
> Hi
>
> Description:
>   We have noticed kernel error message on the dmesg when ltp test cases are 
> executed. We observed multiple instance of error message:
>                   "Not cloning cgroup for unused subsystem ns" in dmesg
>
> Test:
> The messages were seen when ltp test case for the containers are executed:
> ltp -f containers
>
> Solution:
> Alexey Dobriyan had provided a patch to address the issue. Where the printk 
> was removed. The patch still haven't made it to main line and hence we 
> still see the messages.
> The patch can be found here:
>  http://git.openvz.org/?p=linux-2.6.24-openvz;a=log;h=v2.6.24-ovz002.2
>
> Would this be the right way to handle the issue?
> if so
> When can we expect this to be included into mainline

Resend the patch to lkml.  Assuming you are talking about commit id
93af30a60055a83a00188ae04b88bbd9b4e1489a, go ahead and add my
Acked-by.

Converting it to a pr_debug() might be another thing to consider, but
I'm not sure anyone wants these messages.

-serge
