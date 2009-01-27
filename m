Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZA0DM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZA0DM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 22:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZA0DMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 22:12:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:46030 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZA0DMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 22:12:47 -0500
Message-ID: <497E7B3C.1040606@kernel.org>
Date: Tue, 27 Jan 2009 12:10:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re: memory
 	beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y]]
References: <49763718.7010501@kernel.org> <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com> <49794422.2080109@kernel.org> <49797634.7040500@kernel.org> <4979771E.5050001@kernel.org> <49797949.7090906@kernel.org> <497979C1.3030103@kernel.org>
In-Reply-To: <497979C1.3030103@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 27 Jan 2009 03:10:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>>> WARNING: Absolute relocations present
>>>> Offset     Info     Type     Sym.Value Sym.Name
>>>> c14d21ef 00921101   R_386_32 c1514000  __per_cpu_load
>>> Hmm... weird.  Can you please attach the .config file you used and the
>>> commit ID and the version of toolchain?  I'll try to reproduce it
>>> here.
>>>
>> my own config full, got that too
>> WARNING: Absolute relocations present
>> Offset     Info     Type     Sym.Value Sym.Name
>> 40c22260 00d94801   R_386_32 40c7a000  __per_cpu_load

Brian just committed a patch to fix the relocation bug.  Can you
please test the current core/percpu[1]?

[1] 5a611268b69f05262936dd177205acbce4471358

-- 
tejun
