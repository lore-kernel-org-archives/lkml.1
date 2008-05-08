Return-Path: <linux-kernel-owner+w=401wt.eu-S1763070AbYEHPrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763070AbYEHPrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYEHPrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:47:35 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:51485 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbYEHPre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:47:34 -0400
Message-ID: <48232092.9090209@isomerica.net>
Date: Thu, 08 May 2008 11:47:30 -0400
From: Dan Noe <dpn@isomerica.net>
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Brian McGrew <brian@visionpro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Two questions about scheduling and threading.
References: <C448672F.1E24B%brian@visionpro.com>
In-Reply-To: <C448672F.1E24B%brian@visionpro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/2008 11:15, Brian McGrew wrote:
> Also, I know that we're supposed to sit back and let the scheduler do all
> the work for us; but, in the 2.6.16.16 kernel, is there a way to assign a
> specific thread and/or process to a designated processor???  I really need
> to be able to do this because even with the preemptive scheduling, I'm still
> real-time and it's not quite real-time enough!

There are some functions to set CPU affinity from user space:

sched_setaffinity()
sched_getaffinity()

And a user space program:

taskset

All have decent man pages.  They'll allow you to pin a process to a 
particular CPU, or set the normal behavior, which is to try and keep a 
process on the same CPU as long as possible.  There are some other 
utilities mentioned in the related section of the manpages - they allow 
you to tweak scheduler behavior.

Hope that helps.

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noe
                     |  http://isomerica.net/~dpn/
