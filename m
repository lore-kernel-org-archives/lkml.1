Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYIJTuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYIJTuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYIJTuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:50:32 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:51350 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYIJTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:50:31 -0400
Message-ID: <48C8259B.7040702@keyaccess.nl>
Date: Wed, 10 Sep 2008 21:52:59 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: AGP PAT issue.
References: <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl> <48ADF3FC.7070002@keyaccess.nl> <20080822041544.GF30284@elte.hu> <48AF1B6A.80408@keyaccess.nl>
In-Reply-To: <48AF1B6A.80408@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-08-08 22:02, Rene Herman wrote:

> On 22-08-08 06:15, Ingo Molnar wrote:

>> The frontside cache itself is in x86/urgent:
>>
>>  # 80c5e73: x86: fix Xorg startup/shutdown slowdown with PAT
>>
>> ... and should at least solve the symptom that you've hit in practice 
>> (the slowdown), without changing the underlying PAT machinery. (which 
>> would be way too dangerous for v2.6.27)
> 
> Well, please note that that specific commit only fixes X startup -- it 
> doesn't do anything for shutdown. With only that one, I'm still at 14 
> seconds for X shutdown (first time after boot that is, 5 seconds 
> subsequent shutdowns) versus 1 (or sub 1, feels immediate) normally.
> 
> It's also a black-screen "hang", so we'll probably be getting a lot of 
> "long hang at shutdown" reports without something additionally for .27.
> 
> Venki?

Haven't been subcribed to any lists recently and someone was talking 
about "the other thread" before but just noticed that an -rc6 was cut.

Please note that the shutdown issue remains unfixed in it (I'm doing my 
coalescing changes locally).

Rene
