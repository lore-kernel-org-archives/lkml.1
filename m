Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbZAGVB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbZAGVB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbZAGVBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:01:39 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:55748 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754555AbZAGVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:01:38 -0500
Message-ID: <4965182C.3010707@lwfinger.net>
Date: Wed, 07 Jan 2009 15:01:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: BUG in latest GIT 2.6.28-0658-g637b180
References: <49643869.8000500@lwfinger.net> <200901072115.40148.bzolnier@gmail.com>
In-Reply-To: <200901072115.40148.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 07 January 2009, Larry Finger wrote:
>> The latest GIT generates the following BUG.
>>
>>
>> BUG: sleeping function called from invalid context at mm/slab.c:3046
>> in_atomic(): 0, irqs_disabled(): 1, pid: 523, name: modprobe
>> no locks held by modprobe/523.
>> irq event stamp: 17802
>>  [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
> 
> Fix below.  Thanks again Larry!

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

The fix works here.

Larry
