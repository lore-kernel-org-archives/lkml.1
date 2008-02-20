Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbYBTQzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbYBTQzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYBTQzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:55:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:59434 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbYBTQzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:55:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=k6oImxIjnRPYvjDaYsvZ/kmOSGqZqdcmuvbPkDCN2Cg6k7F7TxR1S4QUtNjDOmVQ335h6+4IFfs9H3zma9luw6eD7DX1SdLYeDF1EjC7usoxxxPbn4l5jhSWRmcaUrK7SuFJEmP0JHNhRZ8UNMEKiO1TEFPbAzzXiVAm810GAkM=
Message-ID: <2c0942db0802200854t64e9ac73g41f0031f4cd995d4@mail.gmail.com>
Date: Wed, 20 Feb 2008 08:54:59 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller in Kconfig
Cc: "John Stoffel" <john@stoffel.org>, "Andi Kleen" <andi@firstfloor.org>,
       akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <47BC4554.10304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080220122338.GA4352@basil.nowhere.org>
	 <47BC2275.4060900@linux.vnet.ibm.com>
	 <18364.16552.455371.242369@stoffel.org>
	 <47BC4554.10304@linux.vnet.ibm.com>
X-Google-Sender-Auth: fbb2df582a9d9ba8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 7:20 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> John Stoffel wrote:
>  > I know this is a pedantic comment, but why the heck is it called such
>  > a generic term as "Memory Controller" which doesn't give any
>  > indication of what it does.
>  >
>  > Shouldn't it be something like "Memory Quota Controller", or "Memory
>  > Limits Controller"?
>  >
>
>  It's called the memory controller since it controls the amount of memory that a
>  user can allocate (via limits). The generic term for any resource manager
>  plugged into cgroups is a controller. If you look through some of the references
>  in the document, we've listed our plans to support other categories of memory as
>  well. Hence it's called a memory controller

While logical, the term is too generic. Memory [Allocation] Governor
might be closer. Memory Quota Controller actually matches the already
established terminology (quotas).

Regardless, Andi's point remains: At minimum, the kconfig text needs
to be clear for distributors and end-users as to why they'd want to
enable this, or what reasons would cause them to not enable it.
