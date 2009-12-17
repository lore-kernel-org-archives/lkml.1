Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbZLQGFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbZLQGFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 01:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758554AbZLQGFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 01:05:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbZLQGFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 01:05:17 -0500
Message-ID: <4B29CA73.4050005@redhat.com>
Date: Thu, 17 Dec 2009 01:06:43 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Roland Dreier <rdreier@cisco.com>, Michal Marek <mmarek@suse.cz>,
       Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>	<adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com>	<ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com> <aday6l25gnm.fsf@roland-alpha.cisco.com> <4B29BFE8.1000502@zytor.com> <4B29C652.5080803@redhat.com> <4B29C661.6090800@zytor.com>
In-Reply-To: <4B29C661.6090800@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 12/16/2009 09:49 PM, Masami Hiramatsu wrote:
>>>
>>> I would strongly prefer the following solution as it solves this entire
>>> class of problems globally, although I'd really want Michal's ACK for it:
>>
>> Sure, agreed.
>> BTW, is it possible user to overwrite this setting?
>>
> 
> Doing it this way means the user can override it on the make command line.

Hmm, in that case, as Sam said, some user may do it because
they would like to understand error messages. And that can
cause other problems.

Hrm, if there is just this problem, for now, don't you think
fixing it with my workaround is better choice?

Maybe, locale problem should be discussed more widely.

Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

