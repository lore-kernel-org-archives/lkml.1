Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbZLPWTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbZLPWTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762625AbZLPWTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:19:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:57261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762674AbZLPWTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:19:37 -0500
Message-ID: <4B295CA2.5080201@kernel.org>
Date: Wed, 16 Dec 2009 14:18:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Hancock <hancockrwd@gmail.com>,
       Tvrtko Ursulin <tvrtko@ursulin.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci: don't check mmconf again if it is from MSR with
 amd faml0h
References: <200912130807.44905.tvrtko@ursulin.net>	<200912141934.10628.tvrtko@ursulin.net>	<4B26965C.6020203@kernel.org>	<200912142016.53160.tvrtko@ursulin.net>	<4B269F92.1050909@kernel.org>	<4B26E4C7.8040100@gmail.com>	<4B26F8BD.5070501@kernel.org> <20091216120643.50070952@jbarnes-piketon>
In-Reply-To: <20091216120643.50070952@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Mon, 14 Dec 2009 18:47:25 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> for AMD Fam10h, it we read mmconf from MSR early, we should just
>> trust it because we check it and correct it already.
>>
>> so skip the reject check there.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
> 
> Why is mmconfig getting rejected on this platform?  Seems like that
> should be fixed instead, rather than adding a whitelist of one.
> 

in the previous cleanup, i happen to move the checking to check hostbridge code too.

but don't want to remove the checking for all, and this patch only remove the checking for amd 10h.

YH
