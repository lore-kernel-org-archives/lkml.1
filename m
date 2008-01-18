Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbYARMqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbYARMqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYARMqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:46:33 -0500
Received: from relay1.sgi.com ([192.48.171.29]:36285 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761198AbYARMqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:46:31 -0500
Message-ID: <47909FA4.1020205@sgi.com>
Date: Fri, 18 Jan 2008 04:46:28 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/6] percpu: Change Kconfig ARCH_SETS_UP_PER_CPU_AREA
 to HAVE_SETUP_PER_CPU_AREA
References: <20080117223505.203884000@sgi.com> <20080117223505.513183000@sgi.com> <20080118051118.GA14882@uranus.ravnborg.org>
In-Reply-To: <20080118051118.GA14882@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Hi Mike.
> 
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -20,6 +20,7 @@ config X86
>>  	def_bool y
>>  	select HAVE_OPROFILE
>>  	select HAVE_KPROBES
>> +	select HAVE_SETUP_PER_CPU_AREA if ARCH = "x86_64"
> 
> It is simpler to just say:
>> +	select HAVE_SETUP_PER_CPU_AREA if X86_64
> 
> And this is the way we do it in the rest of the
> x86 Kconfig files.
> 
> 	Sam


Thanks.  Done. :-)

And sorry about the premature mailing.  I have a set of scripts that
package everything up to send to test machines and it wasn't supposed
to trigger the "sendmail" phase to the distro list.  There are a few
build errors (as Ingo has noted) and I'm debugging an X86_64 !NUMA
problem that dies at network startup time.

But I'll add in all the suggestions from the "premature" reviews... :-)

Thanks again,
Mike
