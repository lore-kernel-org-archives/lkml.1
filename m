Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZBEWiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZBEWiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbZBEWiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:38:00 -0500
Received: from tundra.namei.org ([65.99.196.166]:3926 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZBEWh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:37:59 -0500
Date: Fri, 6 Feb 2009 09:37:50 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/7] integrity 
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0902060937340.13175@tundra.namei.org>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Mimi Zohar wrote:

> This patchset contains the IMA integrity patches. The changes made since
> the last integrity posting are based on comments made by James Morris and
> Serge Hallyn.
> - removed test for NULL return code from securityfs_create_file/dir
> - alloc ima_template_entry before calling ima_store_template()
> - log ima_add_boot_aggregate failure
> - free invalid rule
> - add hook to increment opencount for /dev/zero shm
> - replaced hard coded string length with #define name
> - removed unused IMA_TEMPLATE_NAME_LEN
> 
> This patchset is dependent on the tpm-integrity-interface patch, which
> has been applied to the security-testing-2.6/#next.
> 
> Mimi Zohar (7):
>   integrity: IMA hooks
>   integrity: IMA as an integrity service provider
>   integrity: IMA display
>   integrity: IMA policy
>   integrity: IMA policy open
>   Integrity: IMA file free imbalance
>   Integrity: IMA update maintainers

All applied to security-testing.


-- 
James Morris <jmorris@namei.org>

