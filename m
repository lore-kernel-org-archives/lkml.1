Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYDVFqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYDVFqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 01:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYDVFqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 01:46:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:6503 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258AbYDVFqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 01:46:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,692,1199692800"; 
   d="scan'208";a="555492923"
Subject: Re: [PATCH 2.6.25-rc7 001/001] ACPI: workaround for buggy BIOS to
	ignore error LINK CRS method
From: Zhao Yakui <yakui.zhao@intel.com>
To: NoWhereMan <uncommonnonsense@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
In-Reply-To: <f7430a760804210613h69e4b560q774301a1152ef77d@mail.gmail.com>
References: <f7430a760804090842s44ece7bh216d5d28e347955@mail.gmail.com>
	 <20080409161251.0c0e73e9.akpm@linux-foundation.org>
	 <1207824057.8704.12.camel@yakui_zhao.sh.intel.com>
	 <f7430a760804100523t6483dc0cn144429ee7024a7f2@mail.gmail.com>
	 <1208267385.12372.11.camel@yakui_zhao.sh.intel.com>
	 <f7430a760804150121ndfaf065j332ebf1cee3c572@mail.gmail.com>
	 <f7430a760804151538v410f7c64m21d90cb9da8e9baa@mail.gmail.com>
	 <f7430a760804161154o77dd7fc5g622d3bbe4fa1183b@mail.gmail.com>
	 <f7430a760804210613h69e4b560q774301a1152ef77d@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 21:37:47 +0800
Message-Id: <1208871467.14474.57.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 15:13 +0200, NoWhereMan wrote:
> patch is working; cc'ing to ML
> 
Thanks for the test.
I will try to push Len to merge this patch.
> On Wed, Apr 16, 2008 at 8:54 PM, NoWhereMan <uncommonnonsense@gmail.com> wrote:
> > FYI it wasn't latest git but still rc7; I've fast-forwarded now to
> >  rc9, but if no significant changes were made on that part of acpi I'm
> >  sure it will work anyway
> >
> >
> >
> >  On Wed, Apr 16, 2008 at 12:38 AM, NoWhereMan <uncommonnonsense@gmail.com> wrote:
> >  > hi Zhao,
> >  >
> >  >  I've applied the patch to latest linus git, boot went flawlessly
> >  >  (except the usual error messages about _CRS method) and both wireless
> >  >  and USB work, so I'm assuming it worked.
> >  >
> >  >  I'm attaching my dmesg just for reference. I've enabled ACPI debugging
> >  >  in my kernel config.
> >  >
> >  >  thank you a lot for your efforts with this bug
> >  >
> >  >
> >  >
> >  >  On Tue, Apr 15, 2008 at 10:21 AM, NoWhereMan <uncommonnonsense@gmail.com> wrote:
> >  >  > On Tue, Apr 15, 2008 at 3:49 PM, Zhao Yakui <yakui.zhao@intel.com> wrote:
> >  >  >
> >  >  >  >  Will you please try the workaround patch and see whether the problem can
> >  >  >  >  be fixed?
> >  >  >  >  Thanks.
> >  >  >
> >  >  >  I will as soon as possible, thank you for your efforts!
> >  >  >
> >  >
> >

