Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124Ab0AKJxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0AKJxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 04:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062Ab0AKJxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 04:53:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:32916 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab0AKJxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 04:53:00 -0500
Message-ID: <4B4AF4F9.4050102@suse.cz>
Date: Mon, 11 Jan 2010 10:52:57 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Simon Horman <horms@verge.net.au>,
       Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>,
       Sergei Trofimovich <slyfox@inbox.ru>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] Makefile: do not override LC_CTYPE
References: <20100108115745.GA14758@sepie.suse.cz> <1262952988-16563-1-git-send-email-mmarek@suse.cz> <4B47C94E.8070302@redhat.com> <4B47CACA.7080103@zytor.com>
In-Reply-To: <4B47CACA.7080103@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.1.2010 01:16, H. Peter Anvin wrote:
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

In Turkish, uppercase i is İ (I with dot) and lowercase I is ı (i
without dot), see http://en.wikipedia.org/wiki/Dotted_and_dotless_I.

Michal
