Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYJILI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYJILI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbYJILIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:08:19 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:48686 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbYJILIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:08:19 -0400
Message-ID: <48EDE61E.7050908@xenontk.org>
Date: Thu, 09 Oct 2008 16:38:14 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, bob.picco@hp.com
Subject: Re: [PATCH] HPET: Remove the BKL.
References: <1223542535-3272-1-git-send-email-davidjon@xenontk.org> <8763o2t5yu.fsf@basil.nowhere.org>
In-Reply-To: <8763o2t5yu.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> David John <davidjon@xenontk.org> writes:
> 
>> Concurrent access is protected by the spin lock hpet_lock. The
>> BKL is not required.
> 
> You should probably also convert the .ioctl = ... to .unlocked_ioctl.
> Otherwise you still got implicit BKL for the ioctls.
> 
> -Andi
> 

Thanks. I'll fix it up.

David.
