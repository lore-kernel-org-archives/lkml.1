Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbYDJPgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbYDJPgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYDJPf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:35:57 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:5533 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721AbYDJPf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:35:56 -0400
To: Michal Hocko <mhocko@suse.cz>
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee>
	<200804101555.58643.mhocko@suse.cz>
Date: Thu, 10 Apr 2008 17:33:47 +0200
In-Reply-To: <200804101555.58643.mhocko@suse.cz> (Michal Hocko's message of "Thu, 10 Apr 2008 15:55:58 +0200")
Message-ID: <87k5j5n2qs.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Apr 2008 15:27:03.0002 (UTC) FILETIME=[53AA4BA0:01C89B1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> [Adding fsdevel list]
>
> On Tuesday 08 April 2008 10:05:47 am Meelis Roos wrote:
>> Jeff Robertson analyzes the behaviour of different operating systems'
>> 64-bit file offset implementation and concludes that on 32-bit
>> machines, Linux and Solaris lack any locking to keep the two 32-bit
>> halves in sync and this could cause rare file offset corruption.
>>
>> http://jeffr-tech.livejournal.com/21014.html
>
> AFAICS, this race is theoretically possible, but it is very hard (almost 
> impossible) to trigger with a sane file usage pattern. 

We discussed this extensively some time ago in 

http://thread.gmane.org/gmane.linux.file-systems/20712/focus=20771

No solution so far

-Andi
