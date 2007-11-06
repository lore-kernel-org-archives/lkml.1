Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbXKFHSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbXKFHSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 02:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXKFHS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 02:18:28 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:38045 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbXKFHS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 02:18:26 -0500
Message-ID: <4730153D.6040200@nttdata.co.jp>
Date: Tue, 06 Nov 2007 16:18:21 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, crispin@crispincowan.com
Subject: Re: Problem with accessing namespace_sem from LSM.
References: <200711060400.lA640fuE078356@www262.sakura.ne.jp> <20071105201126.6b58bbd1@laptopd505.fenrus.org>
In-Reply-To: <20071105201126.6b58bbd1@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Nov 2007 07:18:23.0823 (UTC) FILETIME=[37A19DF0:01C82045]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2007 1:11 PM, Arjan van de Ven wrote:
> On Tue, 06 Nov 2007 13:00:41 +0900
> Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> 
>> Hello.
>>
>> I found that accessing namespace_sem from security_inode_create()
>> causes lockdep warning when compiled with CONFIG_PROVE_LOCKING=y .
> 
> sounds like you have an AB-BA deadlock...

sed /you/AppArmor shipped with OpenSuSE 10.1 and 10.2/ :)

Though I don't think this deadlock should occur quite often,
it occurs when it occurs. Care should be taken promptly.
There should be no way around for this problem as its nature.
Passing vfsmount parameter to VFS helper functions and
LSM hooks seems to be a good choice to me.

Cheers,
Toshiharu Harada

