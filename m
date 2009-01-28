Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZA1Q5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZA1Q5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZA1Q4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:56:49 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:49299 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbZA1Q4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:56:48 -0500
Message-ID: <49808E3F.1090805@oracle.com>
Date: Wed, 28 Jan 2009 08:56:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-01-28-02-17 uploaded (i386 build errors: cpusets &
 kexec)
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
In-Reply-To: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49808E42.01A6:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-01-28-02-17 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git


10 randconfigs on i386, 1 good build.

The other 9 ended with either of these build errors:

init/main.c:876: error: 'struct task_struct' has no member named 'mems_allowed'
CONFIG_CPUSETS=n


or

kernel/printk.c:142: error: implicit declaration of function 'VMCOREINFO_SYMBOL'
# CONFIG_KEXEC is not set

-- 
~Randy
