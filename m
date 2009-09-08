Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZIHAul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZIHAul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 20:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbZIHAuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 20:50:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:29616 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZIHAuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 20:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,349,1249282800"; 
   d="scan'208";a="491351461"
Subject: Re: linux-next: acpi tree build failure
From: Zhang Rui <rui.zhang@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <lenb@kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20090907234612.078bb650.sfr@canb.auug.org.au>
References: <20090901125748.fb33b2ea.sfr@canb.auug.org.au>
	 <20090907234612.078bb650.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 08:47:49 +0800
Message-Id: <1252370869.3483.420.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

len,

please revert the two ALS patches.

thanks,
rui

On Mon, 2009-09-07 at 21:46 +0800, Stephen Rothwell wrote:
> Hi Len,
> 
> On Tue, 1 Sep 2009 12:57:48 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > drivers/acpi/als.c: In function 'acpi_als_get_mappings':
> > drivers/acpi/als.c:173: error: expected ')' before 'PREFIX'
> > drivers/acpi/als.c: In function 'acpi_als_add':
> > drivers/acpi/als.c:347: error: expected ')' before 'PREFIX'
> > 
> > I have used the version of the acpi tree from next-20090831 for today.
> 
> This is still there ...

