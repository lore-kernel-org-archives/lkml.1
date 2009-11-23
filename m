Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZKWDhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZKWDhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 22:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbZKWDho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 22:37:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:60094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165AbZKWDho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 22:37:44 -0500
Message-ID: <4B0A0341.9090305@kernel.org>
Date: Sun, 22 Nov 2009 19:36:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: crash kernel reserve with reserve_early -v2
References: <4B09E2F9.7040403@kernel.org> <m1my2em0ja.fsf@fess.ebiederm.org>
In-Reply-To: <m1my2em0ja.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> use find_e820_area/reserve_early instead.
>>
>> -v2: address Eric's request, to restore original semantics.
>>      will fail, if the provided address can not be used.
> 
> This patch seems reasonable.
> 
> YH what is the benefit of using reserve_early, and moving
> reserve_crashkernel earlier?

old way mixing find_e820_area and reserve_bootmem like bandit...

also there are some effects to remove bootmem, so we try to reduce bootmem reference.

YH
