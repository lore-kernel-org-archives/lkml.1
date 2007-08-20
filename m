Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbXHTRVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbXHTRVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXHTRVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:21:03 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3678 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbXHTRVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:21:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DH8a2dm/tx0ob/NeOe3eBNT54TnsCcAPhS18En5zUqcA9J8AVx/xCkjiZMq1pbX0O
	w4kQpsOS3Y/B2FsGR3j6Q==
Message-ID: <236ccac0708201020y2bfe4aadj8b1f6df361f61@mail.gmail.com>
Date: Mon, 20 Aug 2007 10:20:48 -0700
From: "San Mehat" <san@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46C9C9C7.8080506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	 <20070815161642.1bfbbe9c.akpm@linux-foundation.org>
	 <46C38AA8.5040202@zytor.com>
	 <1187251248.15063.12.camel@caritas-dev.intel.com>
	 <m11wdzrwl7.fsf@ebiederm.dsl.xmission.com>
	 <86802c440708191646r1caab5d8yd82c55fd2c8262db@mail.gmail.com>
	 <46C9C9C7.8080506@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
> >
> > someone told me that EFI PEI will be 32 bit ( for mem etc
> > initialization), and after that will be 64 bit, so the Run time
> > service will be 64 bit only, and it will only support 64 bit OS with
> > EFI. and they have another mode to emulate the legacy BIOS to boot
> > 32bit OS.
> >
>
> That seems unlikely for e.g. the existing Macs already in the field.
>
> *Sigh.*
>

Actually some implementations do run PEI in 32 bit and DXE/BDS in 64
bit; I'm not sure what Macintosh does though..

-san
