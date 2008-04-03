Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbYDCQc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbYDCQc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 12:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbYDCQcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:32:19 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:48908 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbYDCQcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:32:19 -0400
Message-ID: <47F5067D.9070400@nortel.com>
Date: Thu, 03 Apr 2008 10:31:57 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Tom Horsley <tom.horsley@ccur.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: module parameters versus kernel command line
References: <20080403090053.56f243df@tomh> <20080403083953.42ea3f1d.randy.dunlap@oracle.com> <20080403120425.232cb1ba@tomh>
In-Reply-To: <20080403120425.232cb1ba@tomh>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2008 16:32:01.0333 (UTC) FILETIME=[3E5C2650:01C895A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Horsley wrote:

> I know that part, I'm just wondering if it would be nice to have
> even dynamically loaded modules notice the kernel option
> so that the "usbcore" module would see the "blinkenlights=1"
> parameter from the kernel boot options when dynamically loaded?

What if the module is loaded with parameters, and parameters are also 
specified in the kernel command line?

I'd suggest that the dynamic parameter should probably take precedence, 
as that would allow the user to specify things that were not necessarily 
known at boot time, while still providing a boot-time fallback.

Chris
