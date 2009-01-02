Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZABQbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZABQbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbZABQbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:31:10 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:35885 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbZABQbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:31:08 -0500
Message-ID: <495E40EE.8080904@oracle.com>
Date: Fri, 02 Jan 2009 08:29:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Peter W. Morreale" <pmorreale@novell.com>
CC: linux-kernel@vger.kernel.org, comandante@zaralinux.com, bb@ricochet.net,
       Rik van Riel <riel@nl.linux.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Update of Documentation/ (VM sysctls)
References: <20081231212615.12868.97088.stgit@hermosa.site>	 <495D9222.1060306@oracle.com> <1230909901.3470.242.camel@hermosa.site>
In-Reply-To: <1230909901.3470.242.camel@hermosa.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.495E40F2.0256:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter W. Morreale wrote:
> On Thu, 2009-01-01 at 20:03 -0800, Randy Dunlap wrote:
>> Peter W Morreale wrote:
> 
>>> It assumes that patch: http://lkml.org/lkml/2008/12/31/219 has been applied.
>>> This is probably wrong since that patch is still being reviewed and not
>>> officially accepted as of this patch.  Not sure how to handle this at
>>> all.  
>> Yes, this patch should be done first/regardless of your other (pending) patch.
>>
> 
> Wait a sec...  
> 
> There is a patch interdependency here.
> 
> This patch includes the text for the two proposed sysctls.  If they are
> rejected, then this help text will refer to two non-existent sysctls.
> Minor issue compared to:
> 
> The pdflush sysctl patch was respun to include adding text (against the
> current vm.txt) for the new sysctls.  So that patch will fail to apply
> should this patch be added first. 
> 
> See what I mean? So what do I do?

Sorry about the confusion.  What I meant was that this patch's concept
(moving VM sysctls to Doc/sysctl/vm.txt) should be done first (without
the new pdflush pieces), then the new pdflush pieces should be done on
top of that first patch.  Is that clearer?

-- 
~Randy
