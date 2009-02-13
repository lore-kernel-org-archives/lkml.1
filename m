Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbZBMWDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbZBMWDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 17:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZBMWDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 17:03:07 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:30299 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbZBMWDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 17:03:06 -0500
Message-ID: <4995ED9A.5010802@oracle.com>
Date: Fri, 13 Feb 2009 14:00:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-02-13-12-20 uploaded (i386 mm/filemap.c argh)
References: <200902132020.n1DKKd2F031056@imap1.linux-foundation.org> <4995EC75.8090800@oracle.com>
In-Reply-To: <4995EC75.8090800@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4995EE0D.00C8:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2009-02-13-12-20 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> and will soon be available at
>>
>>    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> 9 of 10 i386 builds failed with:
> 
> mm/filemap.c:517: error: redefinition of '__kcrctab_add_to_page_cache_lru'
> mm/filemap.c:308: error: previous definition of '__kcrctab_add_to_page_cache_lru' was here
> mm/filemap.c:517: error: redefinition of '__kstrtab_add_to_page_cache_lru'
> mm/filemap.c:308: error: previous definition of '__kstrtab_add_to_page_cache_lru' was here
> mm/filemap.c:517: error: redefinition of '__ksymtab_add_to_page_cache_lru'
> mm/filemap.c:308: error: previous definition of '__ksymtab_add_to_page_cache_lru' was here


Wow.  So the first EXPORT_SYMBOL() at line 308 should either be deleted
or it should be
EXPORT_SYMBOL(wait_on_page_writeback_range);



-- 
~Randy
