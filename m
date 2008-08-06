Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbYHFCV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbYHFCV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 22:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYHFCGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 22:06:47 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:58073 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbYHFCGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 22:06:43 -0400
Message-ID: <45269.166.70.238.45.1217987147.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080806020152.GA24801@one.firstfloor.org>
References: <51549.166.70.238.45.1217815820.squirrel@webmail.wolfmountaingroup.com>
    <878wvb6i2o.fsf@basil.nowhere.org>
    <44644.166.70.238.45.1217985860.squirrel@webmail.wolfmountaingroup.com>
    <20080806020152.GA24801@one.firstfloor.org>
Date: Tue, 5 Aug 2008 19:45:47 -0600 (MDT)
Subject: Re: [PATCH 2.6.26 2/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Andi Kleen" <andi@firstfloor.org>
Cc: jmerkey@wolfmountaingroup.com, "Andi Kleen" <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Aug 05, 2008 at 07:24:20PM -0600, jmerkey@wolfmountaingroup.com
> wrote:
>>
>> I'll post some patches with these changes and submit it as a module.  I
>> will of course need to patch the kernel to introduce the die notifiers
>> where
>> they are not and there's the issue of cross call NMI to stop other
>> processors on SMP.
>>
>> That's the real issues, Andi, is the xcall stuff for IPC to control all
>> the processors.
>
> NMIs have die notifiers too. That said a cleaner way would be to
> generalize
> the synchronization code already in kdump and reuse that.
>
> -Andi
>

I can get that done.  debuggers as modules makes more sense anyway.

Jeff




