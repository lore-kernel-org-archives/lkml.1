Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbXCEPGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbXCEPGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933505AbXCEPGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:06:44 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:55969 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932954AbXCEPGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:06:44 -0500
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Mon, 5 Mar 2007 16:06:25 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Michael Tokarev" <mjt@tls.msk.ru>
cc: discuss@x86-64.org, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86_64: add reporting of SVM flags to
 /proc/cpuinfo
Message-ID: <20070305150625.GJ30318@amd.com>
References: <20070305143601.GF30318@amd.com>
 <20070305143911.GG30318@amd.com> <45EC2D43.8010108@tls.msk.ru>
MIME-Version: 1.0
In-Reply-To: <45EC2D43.8010108@tls.msk.ru>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Mar 2007 15:06:26.0719 (UTC)
 FILETIME=[D8B8FAF0:01C75F37]
X-WSS-ID: 69F2EE7C2EW95236-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 05:46:27PM +0300, Michael Tokarev wrote:
> Joerg Roedel wrote:
> > +++ b/arch/x86_64/kernel/setup.c
> > +	static char *x86_svm_flags[] = {
> > +		"npt",
> > +		"lbrv",
> > +		"svmlock",
> > +	};
> 
> A nitpick:
> 
> static const char *const x86_svm_flags[] = ... ?

Right. Its better to mark the array as const. Will wait
for more comments and send an updated patch soon.

Thanks,
Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


