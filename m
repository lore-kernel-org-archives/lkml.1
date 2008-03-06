Return-Path: <linux-kernel-owner+w=401wt.eu-S935460AbYCFVDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935460AbYCFVDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYCFVDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:03:35 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:50718 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935900AbYCFVDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:03:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=dq39WyFnzK7ORwp0ppA1MnxCEbzbEIwy5G2yFtp1gJrsOwrinIfogG3APi3D3c2rT4VNW3yikWddvOS2tb1bgNzKneA0KBB1T1NQBO9oSYoD3zkiFocJizHuHUPEUHvZo+iKPh6MNHKm/jyOpVcevOEWsq6Sus91qmZ5sqqKlG4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-rc3-mm1 (IDE)
Date: Thu, 6 Mar 2008 22:14:20 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <20080304083534.c936fe57.randy.dunlap@oracle.com>
In-Reply-To: <20080304083534.c936fe57.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803062214.21094.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 04 March 2008, Randy Dunlap wrote:
> On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/
> 
> i386 allmodconfig gives me this:
> 
> ERROR: "probe_4drives" [drivers/ide/ide-core.ko] undefined!

It was also reported by Andrew & Stephen but the thing is that it doesn't
happen here with IDE tree, also it is quite strange that only probe_4drives
causes error and other probe_* variables don't.

I think that it is caused by something else in -mm / linux-next...

Thanks,
Bart
