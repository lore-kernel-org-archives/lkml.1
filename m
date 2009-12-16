Return-Path: <linux-kernel-owner+w=401wt.eu-S1762583AbZLPRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583AbZLPRYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762460AbZLPRYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:24:50 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:21859 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762329AbZLPRYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:24:49 -0500
Date: Wed, 16 Dec 2009 09:24:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: linux-next: Tree for December 16 (amd64_edac)
Message-Id: <20091216092424.5f87214c.randy.dunlap@oracle.com>
In-Reply-To: <20091216183212.118c5e14.sfr@canb.auug.org.au>
References: <20091216183212.118c5e14.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B2917D6.0153:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 18:32:12 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> My usual call for calm: please do not put stuff destined for 2.6.34 into
> linux-next trees until after 2.6.33-rc1.
> 
> Changes since 20091215:


When CONFIG_SMP=n, CONFIG_X86_MSR=m:

ERROR: "msrs_free" [drivers/edac/amd64_edac_mod.ko] undefined!
ERROR: "msrs_alloc" [drivers/edac/amd64_edac_mod.ko] undefined!


Should EDAC_AMD64 also depend on SMP?

---
~Randy
