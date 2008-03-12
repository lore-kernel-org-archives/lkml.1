Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYCLXxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYCLXxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYCLXxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:53:34 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:43481 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbYCLXxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:53:33 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c
Date: Thu, 13 Mar 2008 00:53:22 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       randy.dunlap@oracle.com
References: <200802252227.m1PMRwbk020090@sabah.engr.sgi.com>
In-Reply-To: <200802252227.m1PMRwbk020090@sabah.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130053.25259.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 25. February 2008, Jonathan Lim wrote:

> +u64 jiffies_64_to_usecs(const u64 j)
> +{
> +	return div64_64(j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1, HZ_TO_USEC_DEN);
> +}
> +EXPORT_SYMBOL(jiffies_64_to_usecs);

Please also adapt the "BITS_PER_LONG == 32" part from jiffies_to_usecs(), it 
should provide enough resolution to avoid the div64_64() here.

bye, Roman
