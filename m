Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbZGPR2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbZGPR2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932861AbZGPR2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:28:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52901 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833AbZGPR2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:28:19 -0400
Message-ID: <4A5F6356.9080505@redhat.com>
Date: Thu, 16 Jul 2009 13:28:54 -0400
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
Subject: Re: [PATCH -tip -v12 01/11] x86: instruction decoder API
References: <20090716155652.6266.39970.stgit@localhost.localdomain> <20090716155700.6266.71011.stgit@localhost.localdomain> <20090716163708.GB5804@merkur.ravnborg.org>
In-Reply-To: <20090716163708.GB5804@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
>> new file mode 100644
>> index 0000000..01e079a
>> --- /dev/null
>> +++ b/arch/x86/include/asm/inat.h
>> @@ -0,0 +1,125 @@
>> +#ifndef _ASM_INAT_INAT_H
>> +#define _ASM_INAT_INAT_H
> 
> [With reference to comment on patch 2/12...]
> You create inat.h here.
> Could you investigave what is needed to factor out the stuff
> needed from userspace so we can avoid the ugly havk where
> you redefine types.h?

Sorry, I'm a bit confusing.
Would you mean that I should break down user_include.h and
add those redefined types in inat.h?

> Maybe create a inat_types.h + inat.h as we do in other cases?

And inat_types.h has two parts, one for kernel, and one for
userspace(which is moved from user_include.h), is that right?

Thank you,

> 
> Same for the other files that requred the types.h hack.
> 
> 	Sam
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

