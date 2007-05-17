Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbXEQS4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbXEQS4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758228AbXEQS40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:56:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122AbXEQS4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:56:25 -0400
Message-ID: <464CA4D9.4050006@redhat.com>
Date: Thu, 17 May 2007 13:54:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <htejun@gmail.com>, Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Greg KH <greg@kroah.com>
Subject: Re: Oops and Panics in 2.6.21.1, 2.6.20.6 and 2.6.19.2
References: <464A4F56.6080108@tequila.co.jp>	<20070515185350.2e77bf21.akpm@linux-foundation.org>	<464AE56F.3040101@gmail.com>	<20070516082935.fe112ab5.akpm@linux-foundation.org>	<464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org>
In-Reply-To: <20070516091346.3c76cb46.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 16 May 2007 17:40:53 +0200 Tejun Heo <htejun@gmail.com> wrote:
> 
>> I see.  I thought there was different approach on fixing the problem.
>> I'll try to backport the synchronization fix but am afraid it can be too
>> risky for -stable.  If it seems too risky, I'll send a patch to disable
>> reclamation.
> 
> OK.  Sad.  Maybe we add /proc/sys/fs/i-have-lots-of-disks-and-dont-mind-if-it-oopses
> to enable the old behaviour.

Out of curiosity, is there a decent reproducer for this problem, or is 
it just a few lucky individuals? :)

-Eric
