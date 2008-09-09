Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbYIIBWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbYIIBWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 21:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYIIBWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 21:22:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58424 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbYIIBWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 21:22:42 -0400
Date: Tue, 09 Sep 2008 10:21:19 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cleanup to make  remove_memory() arch neutral
Cc: Badari Pulavarty <pbadari@us.ibm.com>, garyhade@us.ibm.com,
       linux-mm@kvack.org, mel@csn.ul.ie, lcm@us.ibm.com,
       linux-kernel@vger.kernel.org, x86@kernel.org, mingo@elte.hu
In-Reply-To: <20080908175621.6dfad0a6.akpm@linux-foundation.org>
References: <1220910754.25932.57.camel@badari-desktop> <20080908175621.6dfad0a6.akpm@linux-foundation.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080909101703.C099.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 08 Sep 2008 14:52:34 -0700
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
> 
> > There is nothing architecture specific about remove_memory().
> > remove_memory() function is common for all architectures which
> > support hotplug memory remove. Instead of duplicating it in every
> > architecture, collapse them into arch neutral function.
> > 
> > Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> > 
> >  arch/ia64/mm/init.c   |   17 -----------------
> >  arch/powerpc/mm/mem.c |   17 -----------------
> >  arch/s390/mm/init.c   |   11 -----------
> >  mm/memory_hotplug.c   |   10 ++++++++++
> >  4 files changed, 10 insertions(+), 45 deletions(-)
> 
> I spent some time trying to build-test this on ia64 and gave up.  How
> the heck do you turn on memory hotplug on ia64?
> 

EXPORT_SYMBOL_GPL(remove_memory) is removed.
It is required by drivers/acpi/acpi_memhotplug.ko.


-- 
Yasunori Goto 


