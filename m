Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406Ab0AIAac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab0AIAac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283Ab0AIAab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:30:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab0AIAaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:30:30 -0500
Message-ID: <4B47CE1A.8070708@redhat.com>
Date: Fri, 08 Jan 2010 19:30:18 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Michal Marek <mmarek@suse.cz>, Simon Horman <horms@verge.net.au>,
       Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>,
       Sergei Trofimovich <slyfox@inbox.ru>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] Makefile: do not override LC_CTYPE
References: <20100108115745.GA14758@sepie.suse.cz> <1262952988-16563-1-git-send-email-mmarek@suse.cz> <4B47C94E.8070302@redhat.com> <4B47CACA.7080103@zytor.com>
In-Reply-To: <4B47CACA.7080103@zytor.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 01/08/2010 04:09 PM, Masami Hiramatsu wrote:
>> Hi Michal,
>>
>> Michal Marek wrote:
>>> Setting LC_CTYPE=C breaks localized messages in some setups. With only
>>> LC_COLLATE=C and LC_NUMERIC=C, we get almost all we need, except for not
>>> so defined character classes and tolower()/toupper(). The former is not
>>> a big issue, because we can assume that e.g. [:alpha:] will always
>>> include a-zA-Z and we only ever process ASCII input. The latter seems
>>> only affect arch/sh/tools/gen-mach-types, which we can handle separately.
>>
>> Hmm, this also affects arch/x/tools/gen-insn-attr-x86.awk.
>> Could you also wrap it?
>>
> 
> This is tolower/toupper()?  Do there exist locales where tolower/toupper
> on ASCII input do weird things, or are we merely hypothesizing?

Isn't it affect [A-Z] or [a-z]? If not, the patch good to me too.

Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

