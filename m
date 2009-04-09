Return-Path: <linux-kernel-owner+w=401wt.eu-S932657AbZDIV0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbZDIV0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZDIVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:25:51 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:39932 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZDIVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:25:50 -0400
Message-ID: <49DE676C.6030802@oracle.com>
Date: Thu, 09 Apr 2009 14:23:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
References: <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain> <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk> <11730.1239311156@redhat.com> <alpine.LFD.2.00.0904091412060.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904091412060.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0209.49DE675A.007D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 9 Apr 2009, David Howells wrote:
>> I should've used:
>>
>> 	stg mail -diff-opts=-M
>>
>> it would appear.  I wonder if this should be the default.
> 
> Ahh. I've never used stg. It seems to have some bad defaults.
> 
> Also, depending on exactly what "stg" does, it is entirely possible that 
> adding that
> 
> 	[diff]
> 		renames
> 
> to your .gitconfig won't help: those kinds of default configuration values 
> are (very much on purpose) ignored for certain low-level git commands, 
> exactly so that you can do reliable scripting without having to worry 
> about some user-specific config files.
> 
>> Note that
>>
>> 	git-diff -M HEAD^ HEAD
>>
>> does not make output that looks like yours.  It's missing the:
>>
>> 	 {include/asm-frv => arch/frv/include/asm}/Kbuild   |    0
>> 	 {include/asm-frv => arch/frv/include/asm}/atomic.h |    0
> 
> Those come from "--summary", which summarizes file creation, deletion and 
> movement. Almost always combined with "--stat", but apparently the 
> "--stat" part is again in that "stg mail" script.

David:  Documentation/SubmittingPatches:/git diff/ =>

'Please use "git diff -M --stat --summary" to generate the diffstat:
the -M enables rename detection, and the summary enables a summary of
new/deleted or renamed files.'

-- 
~Randy
