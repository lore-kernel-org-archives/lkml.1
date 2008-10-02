Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYJBIFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYJBIFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYJBIFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:05:22 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:9369 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYJBIFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=r9qwbkJXKovIKA1ndMgNbpYGIcZm26M/HWYPYkxfDoos9JMKtLZtSb13p4U1+bQcOY
         bNuOmrIDn241bLUURQvHGhL+1Z+ZSoT7ohla8zDkt7L+/w5vsoQiN2uPEBtetgdIlyFg
         RndQovnU6ofy4ALxI9DIbzeDDeKDOMm2LHNkE=
Message-ID: <851fc09e0810020105pb9ac097jb5b7ca7099a7b7a4@mail.gmail.com>
Date: Thu, 2 Oct 2008 16:05:19 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Russ Anderson" <rja@sgi.com>
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure v2
Cc: "Huang Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
       "Jack Steiner" <steiner@sgi.com>
In-Reply-To: <20080929143144.GA116670@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080926200242.GC138671@sgi.com>
	 <1222478495.28661.19.camel@yhuang-dev.sh.intel.com>
	 <20080928150106.GA204845@sgi.com> <20080929143144.GA116670@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Russ,

> After thinking about this, if a new runtime call was added to
> efi_runtime_services_t, then the existing efi_call_virt<n> could be
> used.  This would remove the need to create uv_systab.  I'll post
> a patch shortly.

Please don't touch efi_runtime_services_t, if you do not go through
UEFI standard procedure. It can not be extended in a non-standard way.
Thinking about someone else adds another new field to
efi_runtime_services_t in a conflict way.

Best Regards,
Huang Ying
