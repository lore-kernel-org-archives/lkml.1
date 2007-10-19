Return-Path: <linux-kernel-owner+w=401wt.eu-S1765564AbXJSFQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765564AbXJSFQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 01:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbXJSFQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 01:16:04 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:35140 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbXJSFQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 01:16:03 -0400
Message-ID: <47183D7A.7050902@nortel.com>
Date: Thu, 18 Oct 2007 23:15:38 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Rene Herman <rene.herman@keyaccess.nl>, Rik van Riel <riel@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: OOM notifications
References: <20071018202504.GA2854@dmt>	<4717C43D.6030204@keyaccess.nl> <20071018165238.0537eaa6@bree.surriel.com>	<4717CAEC.50203@keyaccess.nl> <20071018171857.409255de@bree.surriel.com> <4717D7B6.40102@keyaccess.nl> <4717D9BF.4010508@redhat.com>
In-Reply-To: <4717D9BF.4010508@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2007 05:15:42.0769 (UTC) FILETIME=[18AA6A10:01C8120F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:

> I agree.  Applications shouldn't be expected to be yet more complicated
> and have different levels of low memory handling.  You might want to
> give a process a second shot at handling SIGDANGER but after that's it's
> all about preparation for a shutdown.

I disagree.  From an embedded viewpoint it would be nice to have a 
"please free up memory", then a "we really need memory NOW", then 
finally the kernel oom killer.

The advantage of the middle message is that it allows userspace to do 
smarter things if it wants to (for instance, if there is an overall 
system manager or some such thing, it could do a better job of 
restarting tasks than the kernel oom killer since it knows the relative 
importance of tasks).

Chris
