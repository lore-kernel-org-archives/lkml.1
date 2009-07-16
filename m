Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbZGPQvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbZGPQvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932520AbZGPQvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:51:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34166 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441AbZGPQvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:51:05 -0400
Message-ID: <4A5F5AB2.2020401@redhat.com>
Date: Thu, 16 Jul 2009 12:52:02 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>
Subject: Re: [PATCH -tip -v12 01/11] x86: instruction decoder API
References: <20090716155652.6266.39970.stgit@localhost.localdomain> <20090716155700.6266.71011.stgit@localhost.localdomain> <4A5F5326.8060307@zytor.com>
In-Reply-To: <4A5F5326.8060307@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009年07月16日 12:19, H. Peter Anvin wrote:
> Masami Hiramatsu wrote:
>>
>> These opcode maps do NOT include most of SSE and FP opcodes, because
>> those opcodes are not used in the kernel.
>>
> 
> That is not true.

Ah, these opcode maps include some SSE/FP setup opcdes which
are used in the kernel.

I've found that opcodes while running selftest of decoder,
so, I checked asm() code and added those in the maps.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

