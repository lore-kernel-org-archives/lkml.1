Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbXLSKIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbXLSKIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXLSKIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:08:37 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14727 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751863AbXLSKIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:08:36 -0500
Message-ID: <4768ED97.9080905@panasas.com>
Date: Wed, 19 Dec 2007 12:08:23 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Filippos Papadopoulos <psybases@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>	 <20071217031841.f483e5ac.akpm@linux-foundation.org>	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>	 <47666904.8060605@panasas.com> <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
In-Reply-To: <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2007 10:08:26.0278 (UTC) FILETIME=[1887F460:01C84227]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19 2007 at 10:48 +0200, "Filippos Papadopoulos" <psybases@gmail.com> wrote:
> On Dec 17, 2007 2:18 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> I have found one problem. Please try patch [2] below and report.
>> If it still fails try to enable debugging by setting with patch [1]
>> these values at top of drivers/scsi/initio.c. And send dmsgs.
>>
>> Boaz
>>
> 
> 
> I tried patch[2] (addition of   sg++)  at 2.6.24-rc5-mm1 but the
> system hangs after some seconds when the initio driver loads.
> I will try patch[1] next week to see what happens.
>
Please first pull from scsi-rc-fixes git-tree first. it has a couple
of other fixes for initio plus patch[2] included.
(maybe its already in -mm tree I'm not sure).
If still don't work try enable debug with patch[1] and send messages

> Would it be better to open a bug report at bugzilla?
>
I would prefer linux-scsi ml

<snip>

Boaz
