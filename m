Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017Ab0AIAof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0AIAof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670Ab0AIAoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:44:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40630 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0AIAod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:44:33 -0500
Message-ID: <fee949ac4791d5692c8359a1cbb134e0.squirrel@www.zytor.com>
In-Reply-To: <4B47CE1A.8070708@redhat.com>
References: <20100108115745.GA14758@sepie.suse.cz>
    <1262952988-16563-1-git-send-email-mmarek@suse.cz>
    <4B47C94E.8070302@redhat.com> <4B47CACA.7080103@zytor.com>
    <4B47CE1A.8070708@redhat.com>
Date: Fri, 8 Jan 2010 16:43:51 -0800
Subject: Re: [PATCH] Makefile: do not override LC_CTYPE
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Michal Marek" <mmarek@suse.cz>,
       "Simon Horman" <horms@verge.net.au>,
       "Roland Dreier" <rdreier@cisco.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Sergei Trofimovich" <slyfox@inbox.ru>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
User-Agent: SquirrelMail/1.4.19-2.fc11
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jan 2010 16:43:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> H. Peter Anvin wrote:
>> On 01/08/2010 04:09 PM, Masami Hiramatsu wrote:
>>> Hi Michal,
>>>
>>> Michal Marek wrote:
>>>> Setting LC_CTYPE=C breaks localized messages in some setups. With only
>>>> LC_COLLATE=C and LC_NUMERIC=C, we get almost all we need, except for
>>>> not
>>>> so defined character classes and tolower()/toupper(). The former is
>>>> not
>>>> a big issue, because we can assume that e.g. [:alpha:] will always
>>>> include a-zA-Z and we only ever process ASCII input. The latter seems
>>>> only affect arch/sh/tools/gen-mach-types, which we can handle
>>>> separately.
>>>
>>> Hmm, this also affects arch/x/tools/gen-insn-attr-x86.awk.
>>> Could you also wrap it?
>>>
>>
>> This is tolower/toupper()?  Do there exist locales where tolower/toupper
>> on ASCII input do weird things, or are we merely hypothesizing?
>
> Isn't it affect [A-Z] or [a-z]? If not, the patch good to me too.
>

[A-Z][a-z] is what LC_COLLATE is about.

    -hpa

