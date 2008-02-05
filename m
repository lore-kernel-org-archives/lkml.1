Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbYBERBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbYBERBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYBERBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:01:23 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:21665 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751954AbYBERBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:01:22 -0500
Message-ID: <47A89660.1080804@Voltaire.COM>
Date: Tue, 05 Feb 2008 19:01:20 +0200
From: Erez Zilber <erezz@Voltaire.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	 <1201639331.3069.58.camel@localhost.localdomain>	 <adazluoe2t3.fsf@cisco.com>	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp> <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
In-Reply-To: <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2008 17:01:20.0456 (UTC) FILETIME=[BAEB8480:01C86818]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Jan 30, 2008 12:32 AM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>   
>> iSER has parameters to limit the maximum size of RDMA (it needs to
>> repeat RDMA with a poor configuration)?
>>     
>
> Please specify which parameters you are referring to. As you know I
> had already repeated my tests with ridiculously high values for the
> following iSER parameters: FirstBurstLength, MaxBurstLength and
> MaxRecvDataSegmentLength (16 MB, which is more than the 1 MB block
> size specified to dd).
>
>   
Using such large values for FirstBurstLength will give you poor
performance numbers for WRITE commands (with iSER). FirstBurstLength
means how much data should you send as unsolicited data (i.e. without
RDMA). It means that your WRITE commands were sent without RDMA.

Erez
