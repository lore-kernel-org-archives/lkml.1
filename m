Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbZFDIbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbZFDIbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZFDIay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:30:54 -0400
Received: from ozlabs.org ([203.10.76.45]:56901 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbZFDIay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:30:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amerigo Wang <amwang@redhat.com>
Subject: Re: [Patch 4/5] module: trim exception table in module_free()
Date: Thu, 4 Jun 2009 18:00:53 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, hch@infradead.org,
       mingo@elte.hu, akpm@linux-foundation.org
References: <20090604014813.6332.18486.sendpatchset@localhost.localdomain> <20090604014849.6332.35945.sendpatchset@localhost.localdomain>
In-Reply-To: <20090604014849.6332.35945.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041800.54696.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 11:16:37 am Amerigo Wang wrote:
> Just as the comment said, trim the exception table entries when
> module_free() mod->module_init.
>
> Currently, this is only done for x86. Other platforms should
> also fix it like this (except sparc32).

I've taken this one to make it more generic.  I'll leave the x86 maintainers 
to apply the rest.

Thanks,
Rusty.

