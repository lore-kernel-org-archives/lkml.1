Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYI3OKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYI3OKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYI3OKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:10:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:60633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbYI3OKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:10:21 -0400
Message-ID: <48E232FC.1090902@kernel.org>
Date: Tue, 30 Sep 2008 23:09:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <20080924105943.GB2094@anita> <20080925081848.GB2305@anita> <48DEA40D.40709@kernel.org> <20080930081257.GB18961@anita.doom>
In-Reply-To: <20080930081257.GB18961@anita.doom>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Sep 2008 14:10:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kletschke wrote:
> Am 2008-09-28 06:22 +0900 schrieb Tejun Heo:
> 
>> Sorry about lack of response.  I was on vacation after a series of
> 
> Thats no Problem at all :-) I hope the vacation was fine.
> 
>> conferences.  There's a bug entry for this problem and I just posted a
>> patch.
>>
>>   http://bugzilla.kernel.org/show_bug.cgi?id=11615
>>
>> Can you please try the patch attached there and post the result
>> there?
> 
> Well, this Patch simply installs the old weird behaviour with the
> result in sometimes no cold boot possible yielding into
> 
> ataX: link too slow to response ...
> ataX: COMRESET failed (errno=-16)
> 
> After that powercycle required. I wrote it down from memory. If there
> is a detailed log required I can create them tomorrow when I have my
> Hands back onto the machine.

Ah.. okay, so generic is not the only one affected by the original
hardreset problem.  Can you please post the result of "lspci -nn"?

-- 
tejun
