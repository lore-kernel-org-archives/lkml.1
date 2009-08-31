Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZHaLYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZHaLYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZHaLYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:24:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZHaLYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:24:34 -0400
Message-ID: <4A9BB2F2.2050909@redhat.com>
Date: Mon, 31 Aug 2009 14:24:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use __pa_symbol to calculate the address of a C symbol.
References: <1251702271-4797-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1251702271-4797-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2009 10:04 AM, Glauber Costa wrote:
> The use of __pa() to calculate the address of a C-visible symbol
> is wrong, and can lead to unpredictable results. See arch/x86/include/asm/page.h
> for details.
>
> It should be replaced with __pa_symbol(), that does the correct math here,
> by taking relocations into account.
>    

Applied, thanks.

I note that the changelog entry says nothing about what component is 
involved and what the effect of the bug is.  This reduces its usefulness 
for someone looking over the log and trying to see if a particular bug 
is fixed.

-- 
error compiling committee.c: too many arguments to function

