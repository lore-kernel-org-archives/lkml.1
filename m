Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbXHUX7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbXHUX7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXHUX67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:58:59 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:37779 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbXHUX66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:58:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZIVSKY4RfGkHFVqtjIpSKbs6sXB5ncRhvwMolpK/cZiXAlkSk0e8w9aKpaMlNWRQrFnykBlrykSmpDBT5aBH7uhdbJoX8YErmjLxviuWogsSHBi1dUfZ7ldhU4dxUSq7txYD8/M99Wbq+SUf3FrxpPEfcnbiTP8SlUcD+pd86Gg=
Message-ID: <86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>
Date: Tue, 21 Aug 2007 16:58:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Huang, Ying" <ying.huang@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, "Aaron Durbin" <adurbin@google.com>
In-Reply-To: <20070821114548.GI32640@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	 <1187250664.15063.0.camel@caritas-dev.intel.com>
	 <46C45B22.5090701@suse.de>
	 <1187313920.28497.1.camel@caritas-dev.intel.com>
	 <46C5C8C4.4060407@zytor.com>
	 <1187580031.27947.67.camel@caritas-dev.intel.com>
	 <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de>
	 <46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Andi Kleen <ak@suse.de> wrote:
> On Tue, Aug 21, 2007 at 03:41:44AM -0700, H. Peter Anvin wrote:
> > Andi Kleen wrote:
> > >> - "struct boot_params" (the zeropage) is kept as a legacy interface.
> > >
> > > Legacy interface for what?  Just for kexec utils which never should
> > > have been using it anyways keeping backwards cruft around seems
> > > misplac.ed
> >
> > Worse.  LinuxBIOS.  :(
>
> Sigh. Perhaps it should be renamed AntiLinuxBios: it seems to be actively adverse.

current LinuxBIOS's path: the elfboot in LinuxBIOS will prepare the
e820 table, and jump to startup_32 in kernel. is that not good and
simple? kernel is not supposed to switch back and forth to get such
memmap...

Why not using ACPI mean AntiLinux?

YH
