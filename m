Return-Path: <linux-kernel-owner+w=401wt.eu-S933121AbZGPTjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbZGPTjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932454AbZGPTjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:39:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58728 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642AbZGPTjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:39:40 -0400
Message-ID: <4A5F8237.6040105@redhat.com>
Date: Thu, 16 Jul 2009 15:40:39 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>
Subject: Re: [PATCH -tip -v12 02/11] x86: x86 instruction decoder	build-time
 selftest
References: <20090716155652.6266.39970.stgit@localhost.localdomain> <20090716155706.6266.79022.stgit@localhost.localdomain> <20090716162947.GA5804@merkur.ravnborg.org> <4A5F6571.3020002@redhat.com>
In-Reply-To: <4A5F6571.3020002@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
>> You are using the native objdump here.
>> But I assume this fails miserably when you build x86 on a powerpc host.
>> In other words - you broke an allyesconfig build for -next...
>> We have $(OBJDUMP) for this.
> 
> Ah, I see... Would you know actual name of x86-objdump on the powerpc
> (or any other crosscompiling host)? I just set "OBJDUMP=objdump" is OK?
> I'm not so sure about cross-compiling kernel...

Oops, we already have it. Yes, I'll use $(OBJDUMP).


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

