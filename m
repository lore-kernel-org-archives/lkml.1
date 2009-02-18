Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZBRAwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZBRAwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZBRAwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:52:17 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:41452 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbZBRAwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:52:15 -0500
Message-ID: <499B5BE1.60003@oracle.com>
Date: Tue, 17 Feb 2009 16:52:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-02-17-12-33 uploaded (nr_pdflush_threads_min sysctl
 build error)
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org>
In-Reply-To: <200902172050.n1HKorvc028933@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.499B5BB2.0050:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-02-17-12-33 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git


Is there any CONFIG_ symbol associated with $subject sysctl?

'one' is only available (currently) when:

#if defined(CONFIG_DETECT_HUNG_TASK) || defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
static int one = 1;
#endif

so it gives us
kernel/sysctl.c:1067: error: 'one' undeclared here (not in a function)

when one of those is not #defined.

-- 
~Randy
