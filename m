Return-Path: <linux-kernel-owner+w=401wt.eu-S1761818AbYC0Vv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818AbYC0Vv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbYC0Vvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:51:47 -0400
Received: from mail.tmr.com ([64.65.253.246]:51347 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbYC0Vvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:51:47 -0400
Message-ID: <47EC173F.4050309@tmr.com>
Date: Thu, 27 Mar 2008 17:53:03 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: Chris Snook <csnook@redhat.com>, Emmanuel Florac <eflorac@intellique.com>,
       linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
References: <20080325194306.4ac71ff2@galadriel.home>	 <47E975F8.3000702@redhat.com> <e2e108260803260015l5e8ba4f7n4fdbac771b13cbba@mail.gmail.com>
In-Reply-To: <e2e108260803260015l5e8ba4f7n4fdbac771b13cbba@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Tue, Mar 25, 2008 at 11:00 PM, Chris Snook <csnook@redhat.com> wrote:

>>  It means you shouldn't use dd as a benchmark.
> 
> If you want to benchmark write speed, you should add
> oflag=direct,dsync to the dd command line. For benchmarking read speed
> you should specify iflag=direct. Or, even better, you can use xdd with
> the flags -dio -processlock.
> 
No, you want your benchmark to measure performance doing what the 
application does. Do unless you have an application which has been 
heavily Linux-ized you don't want to measure something unrelated to the 
application requirements.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
