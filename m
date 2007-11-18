Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbXKRNyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbXKRNyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 08:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbXKRNx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 08:53:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:36824 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752405AbXKRNxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 08:53:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WXtUTU39DEKK3zMnfRF11vEQiYTzDrySNO0bcsLm6hoyXo66SGSNGN3teNtVTc3X+ySHqzsGnRJaR17cKMV9atKSwAkBwa//T1bnO6mu/+1a1l+hnqyojnqpDTTtDXjjnkbnkN5nG2yMNzJ84pB18Y4fylIlg1s8l1TSP6eiviY=
Message-ID: <474043EC.4000700@gmail.com>
Date: Sun, 18 Nov 2007 14:53:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
References: <Pine.LNX.4.44L0.0711171649100.7748-100000@netrider.rowland.org> <4740332A.80002@gmail.com> <474038C9.3040002@gmail.com> <200711181442.09917.rjw@sisk.pl>
In-Reply-To: <200711181442.09917.rjw@sisk.pl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2007 02:42 PM, Rafael J. Wysocki wrote:
> On Sunday, 18 of November 2007, Jiri Slaby wrote:
>> On 11/18/2007 01:42 PM, Jiri Slaby wrote:
>>> See shot of prints here:
>>> http://www.fi.muni.cz/~xslaby/sklad/susp_hang1.png
>> BTW output from that tree minus the patch:
> 
> Hm, it looks like one of the CPU hotplug notifiers is doing something wrong.
> 
> Can you try to see what happens (with the patch applied) if
> thermal_throttle_cpu_callback() is not registered?

After commenting out
//device_initcall(thermal_throttle_init_device);
it looks like this:
http://www.fi.muni.cz/~xslaby/sklad/susp_hang2.png

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
