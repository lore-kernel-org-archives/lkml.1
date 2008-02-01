Return-Path: <linux-kernel-owner+w=401wt.eu-S1763629AbYBAMBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763629AbYBAMBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbYBAMBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:01:07 -0500
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:47984 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569AbYBAMBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:01:05 -0500
Message-ID: <47A30790.8080402@vlnb.net>
Date: Fri, 01 Feb 2008 14:50:40 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: landman@scalableinformatics.com, fujita.tomonori@lab.ntt.co.jp,
       linux-scsi@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James.Bottomley@hansenpartnership.com, scst-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, FUJITA Tomonori <tomof@acm.org>,
       torvalds@linux-foundation.org
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
References: <adazluoe2t3.fsf@cisco.com>	<20080130083239E.fujita.tomonori@lab.ntt.co.jp>	<e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>	<20080130195635T.tomof@acm.org>	<1201785938.7280.105.camel@haakon2.linux-iscsi.org>	<e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>	<47A1EE54.6000005@vlnb.net> <47A1F67C.4020300@scalableinformatics.com> <e2e108260801310908k516f588cv51c18486b4a495d2@mail.gmail.com>
In-Reply-To: <e2e108260801310908k516f588cv51c18486b4a495d2@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Jan 31, 2008 5:25 PM, Joe Landman <landman@scalableinformatics.com> wrote:
> 
>>Vladislav Bolkhovitin wrote:
>>
>>>Actually, I don't know what kind of conclusions it is possible to make
>>>from disktest's results (maybe only how throughput gets bigger or slower
>>>with increasing number of threads?), it's a good stress test tool, but
>>>not more.
>>
>>Unfortunately, I agree.  Bonnie++, dd tests, and a few others seem to
>>bear far closer to "real world" tests than disktest and iozone, the
>>latter of which does more to test the speed of RAM cache and system call
>>performance than actual IO.
> 
> 
> I have ran some tests with Bonnie++, but found out that on a fast
> network like IB the filesystem used for the test has a really big
> impact on the test results.
> 
> If anyone has a suggestion for a better test than dd to compare the
> performance of SCSI storage protocols, please let it know.

I would suggest you to try something from real life, like:

  - Copying large file tree over a single or multiple IB links

  - Measure of some DB engine's TPC

  - etc.

> Bart Van Assche.
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 

