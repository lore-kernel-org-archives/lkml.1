Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbZLQGPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbZLQGPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 01:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbZLQGPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 01:15:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57352 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759148AbZLQGPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 01:15:48 -0500
Message-ID: <4B29CADE.8020905@zytor.com>
Date: Wed, 16 Dec 2009 22:08:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Roland Dreier <rdreier@cisco.com>, Michal Marek <mmarek@suse.cz>,
       Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>	<adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com>	<ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com> <aday6l25gnm.fsf@roland-alpha.cisco.com> <4B29BFE8.1000502@zytor.com> <4B29C652.5080803@redhat.com> <4B29C661.6090800@zytor.com> <4B29CA73.4050005@redhat.com>
In-Reply-To: <4B29CA73.4050005@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 10:06 PM, Masami Hiramatsu wrote:
> 
> Hmm, in that case, as Sam said, some user may do it because
> they would like to understand error messages. And that can
> cause other problems.
> 

See my other patch.  That doesn't override LC_MESSAGES, which is what
matters there.

> Hrm, if there is just this problem, for now, don't you think
> fixing it with my workaround is better choice?

No, because this problem is not just limited to this one script.

> Maybe, locale problem should be discussed more widely.

Well, this thread is on both LKML and linux-kbuild.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

