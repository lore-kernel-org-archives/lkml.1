Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0BLTeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:34:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab0BLTeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:34:18 -0500
Message-ID: <4B75AD35.3080207@suse.com>
Date: Fri, 12 Feb 2010 14:34:13 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] delayacct: align to 8 byte boundary on 64-bit systems
References: <4B75865B.8000307@suse.com>	<20100212101957.9f4a4a3a.akpm@linux-foundation.org>	<4B75A9F7.4030607@suse.com> <20100212112912.be58b670.akpm@linux-foundation.org>
In-Reply-To: <20100212112912.be58b670.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 02:29 PM, Andrew Morton wrote:
> On Fri, 12 Feb 2010 14:20:23 -0500
> Jeff Mahoney <jeffm@suse.com> wrote:
> 
>>> Seems safe enough.  We'd be safer still if we didn't do this on 64-bit
>>> architectures which don't need it.  ie: x86_64.  But if we do that we
>>> add a risk that people will develop shoddy code which works on x86_64
>>> and doesn't work on ia64.
>>
>> Is there a way to do that without needlessly complicating things? I
>> didn't see any existing infrastructure to do that.
> 
> ifdefs?  I don't think it's worth doing, really.  Probably anyone who
> wrote an application for this copied the getdelays.c code anyway.

Yeah I didn't want to get into #if defined(LIST OF ARCHES) for this. I
was hoping for a way to get the alignment rules for the arch. In the
absence of that, this is good enough. You're probably right about people
just lifting the getdelays.c code.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
