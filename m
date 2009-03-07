Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZCGAEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZCGAEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 19:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZCGAEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 19:04:24 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:38541 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbZCGAEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 19:04:23 -0500
Message-ID: <49B1BA2E.8000406@oracle.com>
Date: Fri, 06 Mar 2009 16:05:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       mchehab@infradead.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -next] dvb/frontends: fix duplicate 'debug' symbol
References: <20090306191311.697e7b97.sfr@canb.auug.org.au>	<49B1949E.2000300@oracle.com> <20090306155958.11b4a186.akpm@linux-foundation.org>
In-Reply-To: <20090306155958.11b4a186.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49B1B9CA.0006:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 06 Mar 2009 13:24:46 -0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> It would also be Good if arch/x86/kernel/entry_32.S didn't have a
>> non-static 'debug' symbol.  OTOH, it helps catch things like this one.
> 
> heh, yes, it's a feature.  We should put it in init/main.c, along with
> 100-odd other dont-do-that-dopey symbols.

hm, I think I'll leave that patch for you or Ingo. ;)

-- 
~Randy
