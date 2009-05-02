Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZEBQQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZEBQQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 12:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbZEBQQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 12:16:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:37569 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755364AbZEBQQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 12:16:43 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19qBdwCUYpq+bXw5cXwkkn3Rhp69x2ReD39Qne9Fl
	ct0kOabvik9+rE
Message-ID: <49FC71E6.4000100@gmx.de>
Date: Sat, 02 May 2009 18:16:38 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Tim Abbott <tabbott@MIT.EDU>, Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, linux-parisc@vger.kernel.org
Subject: Re: [PATCH 3/5] parisc: use new macros for .data.init_task.
References: <1241135719-9286-1-git-send-email-tabbott@mit.edu> <1241135719-9286-2-git-send-email-tabbott@mit.edu> <1241135719-9286-3-git-send-email-tabbott@mit.edu> <1241135719-9286-4-git-send-email-tabbott@mit.edu> <49FBD681.9080605@gmx.de> <20090502141308.GA28342@bombadil.infradead.org>
In-Reply-To: <20090502141308.GA28342@bombadil.infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> On Sat, May 02, 2009 at 07:13:37AM +0200, Helge Deller wrote:
>> I think this patch is wrong, although it is theoretically correct.
>>
>> IIRC, gcc on hppa is not able to provide an alignment >= 8k, which is
>> why we have done the 16k alignment inside the linker script.
>> So, I think this change will prevent the parisc kernel to boot up.
>> Needs testing.
>>
> 
> I think you're confusing this with the 8-byte maximum alignment from
> kmalloc and on-stack that prevents us from just using a 16-byte aligned
> word as a lock on pa1.1?

No, I was not confusing it with the 8byte-alignment.

I really meant that a > 8k alignment was not possible.
I tried exactly the same stuff once and failed.
I think the restriction came from hpux compatibility or some old gas...

Anyway, I just tried some assembly and it seems to work.

> The patch I trimmed from this mail looks correct to me.

If you apply it and it boots OK for you, I'm fine.

Helge
