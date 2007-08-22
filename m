Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbXHVGnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbXHVGnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXHVGnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:43:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:31718 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbXHVGnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sgbk4Sc4Xf7636GurRDoOg1fChJUYwbgYh3PI1w644XAHsJb70U6PXywlzhNgtJoyKJ+TnLS8esTFEC34tO+8PyaBW9S0pO5yfVpMM1r5LcjE/bV/s4+TDc9p5Dryk4F4DAKPh2oU5HLXOMtc63Oe8P+8e5h/7LGLgNBU/ByQNc=
Message-ID: <86802c440708212343x3b1438d3m4bbbfbd04db1f1ef@mail.gmail.com>
Date: Tue, 21 Aug 2007 23:43:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Huang, Ying" <ying.huang@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, "Aaron Durbin" <adurbin@google.com>
In-Reply-To: <20070822012216.GN32640@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187250664.15063.0.camel@caritas-dev.intel.com>
	 <1187313920.28497.1.camel@caritas-dev.intel.com>
	 <46C5C8C4.4060407@zytor.com>
	 <1187580031.27947.67.camel@caritas-dev.intel.com>
	 <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de>
	 <46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de>
	 <86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>
	 <20070822012216.GN32640@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Andi Kleen <ak@suse.de> wrote:
> > current LinuxBIOS's path: the elfboot in LinuxBIOS will prepare the
> > e820 table, and jump to startup_32 in kernel. is that not good and
> > simple?
>
> The problem is that the zero page cannot be changed at all in this
> setup. Or rather it can be only changed by breaking LinuxBios.

So you want to construct e820 table in x86_boot_params from LinuxBIOS
memmap in head64.c?

YH
