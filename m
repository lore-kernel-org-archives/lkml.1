Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858Ab0AZPDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab0AZPDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704Ab0AZPDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:03:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:41876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0AZPDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:03:48 -0500
Message-ID: <4B5F0452.1080306@suse.cz>
Date: Tue, 26 Jan 2010 16:03:46 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       Glenn Sommer <glemsom@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use full path to dnsdomainname and domainname in  scripts/mkcompile_h
References: <d65b1b151001191029o66794c24t228177a8ca544e44@mail.gmail.com>	 <2375c9f91001191926hc80dc50mb264f757295c1337@mail.gmail.com>	 <d65b1b151001200706k7a60eaf9le2a6cf4e1227bdad@mail.gmail.com> <2375c9f91001251955s1dfc70f9p94054b7824a4c4b7@mail.gmail.com>
In-Reply-To: <2375c9f91001251955s1dfc70f9p94054b7824a4c4b7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.1.2010 04:55, Américo Wang wrote:
> On Wed, Jan 20, 2010 at 11:06 PM, Glenn Sommer <glemsom@gmail.com> wrote:
>> Alternatively, if we want it to be more flexible(and allow the above)
>> - we should do something like:
>>
>> domainname_executable=`which domainname`
>> if [ ! -z "$domainname_executable" ] && [ -x "$domainname_executable" ]; then
>>

(or 'if command -v domainname >/dev/null 2>&1; then domainname ...')


> Yeah, this seems better for me.

Me too. Glenn, could you send a complete patch doing this? I'll add it
to the kbuild tree then.

Thanks,
Michal
