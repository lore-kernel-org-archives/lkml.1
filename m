Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbYGACrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbYGACrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 22:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYGACqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 22:46:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYGACqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 22:46:54 -0400
Message-ID: <48699A73.6020207@redhat.com>
Date: Mon, 30 Jun 2008 23:46:11 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 17/39] clobber rbx in putuser_64.S
References: <1214602486-17080-11-git-send-email-gcosta@redhat.com> <1214602486-17080-12-git-send-email-gcosta@redhat.com> <1214602486-17080-13-git-send-email-gcosta@redhat.com> <1214602486-17080-14-git-send-email-gcosta@redhat.com> <1214602486-17080-15-git-send-email-gcosta@redhat.com> <1214602486-17080-16-git-send-email-gcosta@redhat.com> <1214602486-17080-17-git-send-email-gcosta@redhat.com> <1214602486-17080-18-git-send-email-gcosta@redhat.com> <87abh5pxl6.fsf@basil.nowhere.org> <4869497B.5040100@redhat.com> <20080630234504.GA3029@one.firstfloor.org>
In-Reply-To: <20080630234504.GA3029@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> But for this case, I think we can come up with a macro that selects the 
>> appropriate register for each of them. Should be easy to do now that the 
>> code is merged.
> 
> Note that each get_user() backend is ~10 lines or so. If you add
> that many macros you might end up with more code than if you 
> just keep them separate.

I agree I might. But I honestly don't think this is the case here.

Does anyone else have a word on this ?

> While I admit I am also partly to blame for some asm macro
> mess, e.g. in entry.S, I relented and would now advocate
> to minimize macro use in assembler. It simply makes it much
> harder to understand and to change.
> 
> -Andi
> 

