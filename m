Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZBDCyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZBDCyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZBDCyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:54:35 -0500
Received: from ozlabs.org ([203.10.76.45]:54376 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZBDCye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:54:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] kernel: constructor support
Date: Wed, 4 Feb 2009 13:24:29 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>
References: <49883CA9.8030306@linux.vnet.ibm.com>
In-Reply-To: <49883CA9.8030306@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041324.29655.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 23:16:33 Peter Oberparleiter wrote:
> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> 
> Call constructors (gcc-generated initcall-like functions) during
> kernel start and module load. Constructors are e.g. used for gcov data
> initialization.
...
> +#ifdef CONFIG_CONSTRUCTORS
> +	mod->ctors = section_objs(hdr, sechdrs, secstrings, "ctors",
> +				  sizeof(*mod->ctors), &mod->num_ctors);
> +#endif

This looks horribly like untested code: shouldn't that be ".ctors"?

Rusty.
