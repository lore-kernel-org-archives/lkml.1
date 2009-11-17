Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZKQGyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZKQGyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZKQGyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:54:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbZKQGyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:54:07 -0500
Message-ID: <4B0248FA.5040502@redhat.com>
Date: Tue, 17 Nov 2009 01:55:54 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <rdunlap@xenotime.net>, Jim Keniston <jkenisto@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -next 0/3] x86 insn decoder test updates (Re: linux-next:
 Tree for October 29 (x86 posttest))
References: <20091116230611.5250.86656.stgit@harusame> <20091117061352.GE30852@elte.hu>
In-Reply-To: <20091117061352.GE30852@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Here are the patches which update x86 instruction decoder build-time 
>> test. As Stephen reported on linux-next, sometimes objdump decodes bad 
>> instructions as normal. This will cause a false positive result on x86 
>> insn decoder test. This patches update the test as below;
>>
>>  - Show more information with V=1
>>  - Show in which symbol the difference places.
>>  - Just warning instead of build failure.
> 
> yes, -tip testing was showing such build bugs too:
> 
>  Error: ffffffff8104aae3:	c5 83 3d 49 80 ee    	lds    0xffffffffee80493d(%rbx),%eax
>  Error: objdump says 6 bytes, but insn_get_length() says 3 (attr:0)
> 
> it happens with older tools, such as binutils-2.17. Modern binutils 
> (2.19) is fine.

Thank you for telling me.

> We dont want to remove the build error: it helped us fix a number of 
> real bugs in the decoder - instead please try to create a make based 
> workaround based on binutils, to not run the test with binutils older 
> than 2.19 or so.

OK, that's fine for me.

Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

