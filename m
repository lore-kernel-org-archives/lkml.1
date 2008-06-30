Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbYF3Uo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbYF3Uo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764193AbYF3Uoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:44:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763281AbYF3Uoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:44:37 -0400
Message-ID: <4869458D.9060603@redhat.com>
Date: Mon, 30 Jun 2008 17:43:57 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 15/39] don't save ebx in putuser_32.S
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>	<1214602486-17080-2-git-send-email-gcosta@redhat.com>	<1214602486-17080-3-git-send-email-gcosta@redhat.com>	<1214602486-17080-4-git-send-email-gcosta@redhat.com>	<1214602486-17080-5-git-send-email-gcosta@redhat.com>	<1214602486-17080-6-git-send-email-gcosta@redhat.com>	<1214602486-17080-7-git-send-email-gcosta@redhat.com>	<1214602486-17080-8-git-send-email-gcosta@redhat.com>	<1214602486-17080-9-git-send-email-gcosta@redhat.com>	<1214602486-17080-10-git-send-email-gcosta@redhat.com>	<1214602486-17080-11-git-send-email-gcosta@redhat.com>	<1214602486-17080-12-git-send-email-gcosta@redhat.com>	<1214602486-17080-13-git-send-email-gcosta@redhat.com>	<1214602486-17080-14-git-send-email-gcosta@redhat.com>	<1214602486-17080-15-git-send-email-gcosta@redhat.com>	<1214602486-17080-16-git-send-email-gcosta@redhat.com> <87ej6hpxoe.fsf@basil.nowhere.org>
In-Reply-To: <87ej6hpxoe.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Glauber Costa <gcosta@redhat.com> writes:
> 
>> clobber it in the inline asm macros, and let the compiler do this for us.
> 
> I would expect that definitely will cause code size regressions ...
> 
> -Andi

Andi,

Thanks for reviewing my patches.

Although I agree with you, I think the reduced codesize is not enough a 
reason to keep code duplicated. If you can provide a version of it that 
is granted to reduce the code size for both i386 and x86_64, or even one 
that makes it minimal for x86_64 and yet, works with i386, fine.

Otherwise, I still think this is the best option.
